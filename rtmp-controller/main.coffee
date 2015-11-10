express = require "express"
bodyParser = require "body-parser"
log = require("./log")

port = process.env.PORT or 80
environment = process.env.NODE_ENV or "production"

app = express()

app.use bodyParser.urlencoded extended: true
app.use bodyParser.json()

#app.get "/ping", (req, res) -> res.sendStatus 200

#app.use "", require("./router")
app.use "/", require("./rtmp-router")

app.listen port, -> log.info "Listening on port #{port}"