Promise = require "promise"
request = require "request"

ETCD_ADDRESS = process.env.ETCD_ADDRESS

module.exports =
	isRunning: (streamName) ->
		return new Promise (resolve, reject) ->
			uri = "#{ETCD_ADDRESS}/transcoders/#{streamName}/hls"

			request.get uri: uri, json: true, (err, msg, body) ->
				if err?
					reject err
					return

				if body.errorCode?
					reject new Error "#{body.message}: #{body.cause}"
					return

				resolve true

	start: (streamName) ->
		