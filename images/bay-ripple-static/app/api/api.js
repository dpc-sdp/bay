"use strict";
const queue =  require('./queue');

exports.settings = () => {
  return {
    project: process.env.TARGET_PROJECT,
    quant_customer: process.env.QUANT_CUSTOMER,
    quant_project: process.env.QUANT_PROJECT,
    quant_token: process.env.QUANT_TOKEN,
    build_dir: process.env.BUILD_DIR || "dist",
    pages: []
  }
}

exports.deploy = async (req, res) => {
  let settings = module.exports.settings()
  settings.pages = req.body.pages || [];
  settings.force = req.body.force || false;
  settings.skipUnpublish = req.body.skipUnpublish || false;
  settings.attachments = req.body.attachments || true
  queue.queue(settings);
  res.json({status: "queued"})
}
