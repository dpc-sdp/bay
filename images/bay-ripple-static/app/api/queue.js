"use strict"
const Queue = require('bull');

let deployQueue;

// Add Redis support to the queue.
if (process.env.REDIS_HOST) {
  const connectionString = process.env.REDIS_HOST ? 'redis://' + process.env.REDIS_HOST + ':6379' : 'redis://redis:6379';
  deployQueue = new Queue('quant deploy', connectionString);
} else {
  // If the  environment has been deployed wihtout Redis support, we can keep an in memory
  // queue, this is less desirable as it will not be persistent but can keep the deployment
  // of the ripple-static builder simple.
  deployQueue = new Queue('quant deploy')
}

const util = require('util');
const exec = util.promisify(require('child_process').exec);

deployQueue.process(async function(job, done) {
  let quantCommand = `quant deploy -c ${job.data.quant_customer} -p ${job.data.quant_project} -t "${job.data.quant_token}" -r /tmp ${job.data.build_dir}`

  const commandOpts = {
    cwd: '/app',
    env: {
      ...process.env,
    }
  }

  if (job.data.force) {
    quantCommand += ` -f`
  }

  if (job.data.attachments) {
    quantCommand += ` -a`
  }

  if (job.data.skipUnpublish) {
    quantCommand += ` -u`
  }

  const data = job.data
  data.quant_token = '****'

  try {
    console.log(JSON.stringify({"status": "preparing", id: job.id, data}))
    await exec('npm run generate', commandOpts )
  } catch (e) {
    console.log("Unable to build site:", e)
    return
  }

  try {
    console.log(JSON.stringify({'status': 'testing', id: job.id, data}))
    await exec('npm run test:static', commandOpts)
  } catch (e) {
    console.log("Static tests failed:", e)
    return
  }

  try {
    console.log(JSON.stringify({'status': 'deploy', id: job.id, data}))
    const {stdout} = await exec(quantCommand, commandOpts)
  } catch (e) {
    console.log("Unable to deploy:", e)
    return
  }
  console.log(JSON.stringify({'status': 'complete', id: job.id, data}))
  done();
})

exports.queue = (data) => {
  deployQueue.add(data)
}
