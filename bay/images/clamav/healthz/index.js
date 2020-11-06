const { execSync } = require('child_process')
const http = require('http')
const net = require('net')

/**
 * Check the clam daemons ability to scan files.
 *
 * @return bool
 *   If it detected a virus or not.
 */
function clamd() {
  let status

  try {
    status = execSync('clamdscan /app/eicar.com')
  } catch (err) {
    return err.stdout.toString().indexOf('Infected files: 1') > -1
  }

  return false
}

/**
 * Send a response.
 */
function respond(res, body = {}, status = 400) {
  let headers = {'Content-Type': 'application/json'}
  res.writeHead(status, headers)
  res.write(JSON.stringify(body))
  res.end()
}

http.createServer(async (req, res) => {
  let body = {}
  const client = new net.Socket()

  client.on('error', () => {
    body.error = true
    body.msg = "Unable to connect to clam daemon."
    return respond(res, body)
  })


  client.on('connect', () => {
    if (!clamd()) {
      body.error = true
      body.msg = "Clamd is not ready"
      respond(res, body)
    }
    client.end()
    return respond(res, {"status": "okay"}, 200)
  })

  // This attempts to connect to the clamdaemon service running on the host.
  client.connect(3310, '0.0.0.0')

}).listen(3000);
