moment = require "moment"
mongoose = require "mongoose"
log = require("log4js").getLogger "mongo/models/LiveChannel"

liveChannelSchema = new mongoose.Schema

	channelName:
		type: String
		index: unique: true

	rtmpAddress: String

	since:
		type: Date
		default: -> moment.utc().toDate()

	updated:
		type: Date
		index: expires: "1m"
		default: Date.now # Not UTC but server time

model = mongoose.model "LiveChannel", liveChannelSchema

module.exports = 
	model: model

	facade: 
		save: (channelName, rtmpAddress) ->
			log.trace "Entering save(#{channelName}, #{rtmpAddress})"
			return new Promise (resolve, reject) ->
				log.trace "Entering save(#{channelName}, #{rtmpAddress}) promise"
				model.update { channelName: channelName },
					{ channelName: channelName, rtmpAddress: rtmpAddress, updated: Date.now() }
					{ upsert: true }
					(err) ->
						log.trace "Entering save(#{channelName}, #{rtmpAddress}) mongo callback"
						if err?
							log.error "Error in update(#{channelName}, #{rtmpAddress}): #{err}"
							reject err
						else
							resolve()

		findRtmpAddress: (channelName) ->
			log.trace "Entering findRtmpAddress(#{channelName})"
			return new Promise (resolve, reject) ->
				model.findOne channelName: channelName, "rtmpAddress", lean: true, (err, doc) ->
					log.trace "Entering findRtmpAddress(#{channelName}) mongo callback"
					if err? or not doc?.rtmpAddress?
						log.error "Error in findRtmpAddress(#{channelName}): #{err}"
						reject err
						return

					resolve doc?.rtmpAddress