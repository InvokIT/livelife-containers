mongoose = require "mongoose"

mongoose.set "debug", process.env.NODE_ENV isnt "production"

console.info "NODE_ENV: #{process.env.NODE_ENV}"

serverHost = process.env.MONGO_HOST or "mongodb"

module.exports = require("./mongo/db")(serverHost)