mongoose = require "mongoose"
log = require("log4js").getLogger "mongo/models/LiveChannel"

schema = new mongoose.Schema

	channelName:
		type: String
		index: unique: true

	rtmpAddress: String

	since:
		type: Date
		default: Date.now

	updated:
		type: Date
		index: expires: "1m" # In 1 minute after current server time
		default: Date.now # Not UTC but server time

facadeExtensions =
	save: (model, channelName, rtmpAddress) ->
		log.trace "Entering save(#{channelName}, #{rtmpAddress})"

		return new Promise (resolve, reject) ->
			log.debug "Entering save(#{channelName}, #{rtmpAddress}) promise"

			model.update { channelName: channelName },
				{
					$setOnInsert: { channelName: channelName, since: Date.now() }
					$set: { rtmpAddress: rtmpAddress, updated: Date.now() }
				}
				{ upsert: true }
				(err) ->
					log.trace "Entering save(#{channelName}, #{rtmpAddress}) mongo callback"
					if err?
						log.error "Error in update(#{channelName}, #{rtmpAddress}): #{err}"
						reject err
					else
						resolve()

	findRtmpAddress: (model, channelName) ->
		log.trace "Entering findRtmpAddress(#{channelName})"

		return new Promise (resolve, reject) ->
			log.debug "Entering findRtmpAddress(#{channelName}) promise"

			model.findOne channelName: channelName, "rtmpAddress", lean: true, (err, doc) ->
				log.trace "Entering findRtmpAddress(#{channelName}) mongo callback"
				if err?
					log.error "Error in findRtmpAddress(#{channelName}): #{err}"
					reject err
					return

				resolve doc?.rtmpAddress or null

module.exports = 
	schema: schema
	facadeExtensions: facadeExtensions
