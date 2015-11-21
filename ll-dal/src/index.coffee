mongoose = require "mongoose"
k8s = require "./k8s"
log = require("log4js").getLogger "index"

environment = process.env.NODE_ENV

mongoose.set "debug", environment isnt "production"

podLabelSelector = process.env.MONGO_POD_SELECTOR or "app=mongodb"

hostLocator = -> k8s.getPodAddresses podLabelSelector

if process.env.DAL_DEBUG_HOST?
	hostLocator = -> Promise.resolve [process.env.DAL_DEBUG_HOST]

module.exports = require("./mongo/db") hostLocator, "rs0"
