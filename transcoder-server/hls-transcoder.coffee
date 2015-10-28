spawn = require("child_process").spawn
uuid = require("uuid").v4
log = require("log4j").getLogger "hls-transcoder"

transcoderPath = "/usr/local/bin/hls-transcode.sh"

class HlsTranscoder
	constructor: (@rtmpUri, @streamName) ->

	start: ->
		return new Promise (resolve, reject) ->
			log.trace "Starting transcoder"

			outputPrefix = uuid()

			transcoderProcess = spawn transcoderPath, [@rtmpUri, @streamName, outputPrefix]

			transcoderProcess.on "error", (err) => @_onError err

			transcoderProcess.on "exit" (code, signal) => @_onExit code, signal

	stop: ->

	_onExit: (code, signal) ->

	_onError: (err) ->
		

module.exports = create: (streamName) -> new HlsTranscoder streamName