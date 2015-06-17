async = require "async"
Promise = require "promise"
log = require("./log").getLogger "RadioChannel"

class RadioChannel
	constructor: (clientSocket, @msgbus, @cache) ->
		@queue = async.queue (line) => @handleLine line
		@socket = clientSocket

		clientSocket.setEncoding "utf8"
		clientSocket.on "data", (data) => @handleData data

	handleData: (data) ->
		queue.push l for l in data.split "\n"

	handleLine: (line, cb) ->
		log.trace "entering handleLine { line: #{line} }"
		[cmd, params...] = line.split /\s+/

		log.debug "handleLine { cmd: #{cmd}, params: #{JSON.stringify params}"

		fnName = "handleCmd#{cmd}"

		if not @[fnName]?
			log.error "handleLine - unknown command #{cmd}, closing socket"
			@socket.destroy()
			cb(new Error "unknown command: #{cmd}")

		@[fnName](socket, params...).nodeify cb

	handleGet: (key) ->
		socket = @socket

		return @cache.get key
		.then (value) ->
			new Promise (resolve, reject) ->
				value = JSON.stringify value if typeof value isnt "string"
				socket.write value, -> resolve()
		, (err) ->
			socket.destroy()
			return err


module.export = RadioChannel