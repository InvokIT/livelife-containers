express = require "express"
bodyParser = require "body-parser"

port = process.env.PORT or 80
environment = process.env.NODE_ENV or "production"

Cache =
	switch environment
		when "debug" then require "./cache-local"
		when "production" then require "./cache-redis"

log = require("./log").getLogger "cache-server"

app = express()

app.use bodyParser.urlencoded extended: true
app.use bodyParser.json()

app.get "/ping", (req, res) -> res.sendStatus 200

app.use "", require("./router-cache")(new Cache)

app.listen port, -> log.info "Listening on port #{port}"