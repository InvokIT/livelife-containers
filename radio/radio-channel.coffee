Promise = require "promise"
log = require("./log").getLogger "RadioChannel"

class RadioChannel
	constructor: (clientSocket, @msgbus, @cache) ->
		@socket = clientSocket
		@dataListener = (data) => @handleData data

		clientSocket.setEncoding "utf8"
		clientSocket.on "data", (data) => @dataListener data

	handleData: (data) ->
		log.trace "entering handleData { data: #{data} }"

		data = JSON.parse data
		cmd = Object.keys(data)[0]
		if not cmd?
			log.error "handleData - no command specified, closing socket"
			@socket.destroy()

		params = data[cmd]

		log.debug "handleData { cmd: #{cmd}, params: #{JSON.stringify params}"

		cmd = cmd[0].toUpperCase() + cmd[1..].toLowerCase()

		fnName = "handleCmd#{cmd}"

		if not @[fnName]?
			log.error "handleData - unknown command #{cmd}, closing socket"
			@socket.destroy()
			return

		@[fnName](params)
		return

	handleCmdPublish: (params) ->
		log.trace "entering handlePublish { params: #{params} }"

		{ channel, message } = params

		if not channel? or not message?
			log.error "handlePublish { channel: #{channel}, message: #{message} }, error: channel or message not specified"
			@socket.end { error: "channel or message not specified" }

		@msgbus.publish channel, message
		.then (=> @socket.end { channel, message } )
			, (err) =>
				log.error "handlePublish { channel: #{channel}, message: #{message} }, error: #{err}"
				@socket.end { error: err.message }

	handleCmdSubscribe: (channel) ->
		log.trace "entering handleSubscribe { channel: #{channel} }"

		@dataListener = (data) =>
			log.warn "handleSubscribe { channel: #{channel} }, received data from client while subscribed: #{data}"

		onMessage = (msg) =>
			@socket.write { channel, message: msg }

		@socket.on "end", => 
			@msgbus.unsubscribe channel, onMessage
			@socket.end()

		@msgbus.subscribe channel, onMessage
		.then ( => @socket.write { subscribe: channel } )
		, (err) => 
			log.error "handleSubscribe { channel: #{channel} }, error: #{err}"
			@socket.end { error: err }


module.exports = RadioChannel