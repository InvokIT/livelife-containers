express = require "express"
bodyParser = require "body-parser"
<<<<<<< HEAD
=======
log = require("./log").getLogger "main"
>>>>>>> 48935cff9ae48f09e1586863b22ab9d1fa0637aa

port = process.env.PORT or 80
environment = process.env.NODE_ENV or "production"

app = express()

app.use bodyParser.urlencoded extended: true
app.use bodyParser.json()

app.get "/ping", (req, res) -> res.sendStatus 200

app.use "/", require("./transcoder-manager-router")

app.listen port, -> log.info "Listening on port #{port}"