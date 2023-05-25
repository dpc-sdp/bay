const express = require('express')
const router = express.Router()
const api = require('./api/api')

router.post('/deploy', api.deploy)

module.exports = router
