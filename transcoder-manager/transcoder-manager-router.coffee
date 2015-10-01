express = require "express"
router = express.Router()
Promise = require "promise"

log = require "./log"

startHlsTranscoder = (streamName) ->
	return new Promise (resolve, reject) ->
		# TODO Start a transcoder instance
		log.error "startTranscoder not implemented."
		reject()

router.post "/:streamName/hls/start", (req, res) ->
	streamName = req.params.streamName
	log.trace "#{streamName}/hls/start"

	request.get uri: "http://cache/streams/#{streamName}/transcoder/hls", (err, msg, result) ->
		if err? then # Transcoder is not running, so start it
			startHlsTranscoder(streamName).then -> res.sendStatus(201), -> res.sendStatus(500)
		else
			res.sendStatus 204

	if isTranscoderRunning
		res.sendStatus 204
	else
		startTranscoder(streamName).then -> res.sendStatus(201), -> res.sendStatus(500)

module.exports = router