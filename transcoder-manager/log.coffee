log = require "log4js"
###
if process.env.NODE_ENV is "debug"
	log.setLevel "all"
###
module.exports = log.getLogger "transcoder-manager"