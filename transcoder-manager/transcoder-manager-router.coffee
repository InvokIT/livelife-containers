express = require "express"
router = express.Router()
log = require("log4js").getLogger "transcoder-manager-router"
Transcoder = require "./k8s/Transcoder"

router.post "/:streamName/hls/start", (req, res) ->
	streamName = req.params.streamName
	log.trace "#{streamName}/hls/start"

	transcoder = Transcoder.get streamName, "hls"

	transcoder.isRunning()
	.catch res.sendStatus 500
	.then (isRunning) ->
		if isRunning
			res.sendStatus 204
		else
			transcoder.start()
			.then -> res.sendStatus 201
			.catch -> res.sendStatus 500

router.post "/:streamName/hls/stop", (req, res) ->
	streamName = req.params.streamName
	log.trace "#{streamName}/hls/stop"

	transcoder = Transcoder.get(streamName)

	transcoder.isRunning()
	.catch res.sendStatus 500
	.then (isRunning) ->
		if !isRunning
			res.sendStatus 204
		else
			transcoder.stop()
			.then -> res.sendStatus 201
			.catch -> res.sendStatus 500

module.exports = router