mongoose = require "mongoose"
k8s = require "./k8s"
log = require("log4js").getLogger "index"

environment = process.env.NODE_ENV

mongoose.set "debug", environment isnt "production"

podLabelSelector = process.env.MONGO_POD_SELECTOR

if podLabelSelector?
	try
		podLabelSelector = JSON.parse podLabelSelector
	catch err
		log.error "Could not parse MONGO_POD_SELECTOR: #{err}"
		podLabelSelector = null
else
	podLabelSelector = app: "mongodb"

hostLocator = -> k8s.getPodAddresses podLabelSelector

if process.env.DAL_DEBUG_HOST?
	hostLocator = -> Promise.resolve [process.env.DAL_DEBUG_HOST]

module.exports = require("./mongo/db") hostLocator, "rs0"
