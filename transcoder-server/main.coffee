express = require "express"
bodyParser = require "body-parser"
log = require("./log").getLogger "main"
TranscoderManager = require "transcoder-manager"

port = process.env.PORT or 80
environment = process.env.NODE_ENV or "production"

app = express()

app.use bodyParser.urlencoded extended: true
app.use bodyParser.json()

#app.get "/ping", (req, res) -> res.sendStatus 200

app.use "/", require("./transcoder-manager-router").create(TranscoderManager.create())

app.listen port, -> log.info "Listening on port #{port}"