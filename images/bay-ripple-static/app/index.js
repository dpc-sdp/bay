require('dotenv').config()
const express = require('express')
const app = express()
const apiRouter = require('./router')

const queue = require('./api/queue')

app.use(express.json())

app.get('/', (req, res) => {
  res.json({
    "status": "listening",
    "project": process.env.TARGET_PROJECT,
    "quant_customer": process.env.QUANT_CUSTOMER,
    "quant_project": process.env.QUANT_PROJECT,
    "queue_ready": queue.ready(),
  })
})

app.use('/api', apiRouter)

app.listen(3000, function () {
  console.log('Listening on port 3000!')
})
