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

	,
		read: "primary"

facadeExtensions =
	save: (model, channelName, rtmpAddress) ->
		log.trace "save(#{channelName}, #{rtmpAddress})"

		model.update { channelName: channelName },
			{
				$setOnInsert: { channelName: channelName, since: Date.now() }
				$set: { rtmpAddress: rtmpAddress, updated: Date.now() }
			}
			{ upsert: true }
		.exec()
		.catch (err) ->
			log.error "update(#{channelName}, #{rtmpAddress}): #{err}"

	findRtmpAddress: (model, channelName) ->
		log.trace "findRtmpAddress(#{channelName})"

		model.findOne { channelName: channelName }, { rtmpAddress: true }, { lean: true }
		.exec()
		.then (doc) ->
			log.trace "findRtmpAddress(#{channelName}) mongo callback"
			return doc?.rtmpAddress or null
		.catch (err) ->
			log.error "findRtmpAddress(#{channelName}): #{err}"

	remove: (model, channelName) ->
		log.trace "remove(#{channelName})"

		model.remove channelName: channelName
		.exec()

module.exports = 
	schema: schema
	facadeExtensions: facadeExtensions
