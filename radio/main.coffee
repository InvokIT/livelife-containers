express = require "express"
bodyParser = require "body-parser"

port = process.env.PORT or 80
environment = process.env.NODE_ENV or "production"

Radio = 
	switch environment
		when "debug" then require "./radio-local"
		when "production" then require "./radio-redis"

log = require("./log").getLogger "radio-server"

app = express()

app.use bodyParser.urlencoded extended: true
app.use bodyParser.json()

app.get "/ping", (req, res) -> res.sendStatus 200

app.use "", require("./router-radio")(new Radio)

app.listen port, -> log.info "Listening on port #{port}"