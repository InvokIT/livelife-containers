express = require "express"
bodyParser = require "body-parser"
log = require("log4js").getLogger "main"

if process.env.NODE_ENV is "production"
	require("log4js").setGlobalLogLevel "[all]", "INFO"

port = process.env.PORT or 80

app = express()

app.set 'trust proxy', ["loopback", "uniquelocal"]

app.use bodyParser.urlencoded extended: true
app.use bodyParser.json()

#app.get "/ping", (req, res) -> res.sendStatus 200

#app.use "", require("./router")
app.use "/", require("./rtmp-router")

server = app.listen port, -> log.info "Listening on port #{port}"

process.on "SIGINT", ->
	server.close()
	process.exit()