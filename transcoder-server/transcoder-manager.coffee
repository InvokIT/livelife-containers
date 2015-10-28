HlsTranscoder = require "hls-transcoder"
etcd = require("node-etcd")(process.env.ETCD_HOST, process.env.ETCD_PORT)
Promise = require "promise"
log = require("log4j").getLogger "TranscoderManager"

class TranscoderManager
	constructor: ->
		@transcoders = {}

	start: (streamName, format) ->
		statusPath = @_buildStatusPath streamName, format
		statusKey = @_buildStatusKey streamName, format

		return new Promise (resolve, reject) =>
			# Only start if there's not already a similar transcoder running somewhere
			etcd.set statusKey, "starting", prevExist: false, (err) =>
				if err?
					return reject(err)

				log.trace "Locating the RTMP server receiving stream #{streamName}"
				etcd.get "/streams/#{streamName}/rtmp", (err, res) ->
					if err?
						return reject(err)

					rtmpServerUri = res.node.value

					transcoder = @_createTranscoder rtmpServerUri, streamName, format
					transcoderKey = @_buildTranscoderKey streamName, format

					onStart = =>
						etcd.set statusKey, "started", (err) ->
							if err?
								onError(err)
							else
								@transcoders[transcoderKey] = transcoder
								resolve()

					onError = (err) =>
						transcoder.stop()
						delete @transcoders[transcoderKey]
						etcd.rmdir statusPath
						reject err

					transcoder.start().then onStart, onError

	stop: (streamName, format) ->
		transcoderKey = @_buildTranscoderKey streamName, format
		transcoder = @transcoders[transcoderKey]

		if not transcoder? then return Promise.reject new Error "This manager does now know the specified stream."

		delete @transcoders["#{format}-#{streamName}"]

		return Promise.all [
				transcoder.stop(),
				Promise.denodeify(etcd.rmdir)(statusPath) #TODO
			]

	statistics: ->
		return transcoders: @transcoders.length

	_createTranscoder: (rtmpServerUri, streamName, format) ->
		switch format
			when "hls" then return HlsTranscoder.create rtmpServerUri, streamName
			else throw new Error "Unknown format: #{format}"

	_buildStatusPath: (streamName, format) ->
		return "/transcoders/#{format}/#{streamName}"

	_buildStatusKey: (streamName, format) ->
		return @_buildStatusPath + "/status"

	_buildTranscoderKey: (streamName, format) ->
		return "#{format}-#{streamName}"

module.exports = create: new TranscoderManager