net = require "net"
Promise = require "promise"

class RadioClient
	constructor: (@host, @port) ->
		@subscriptions = {}

	publish: (channel, message) ->
		sendRequest { publish: { channel, message } }

	subscribe: (channel, onMessage) ->
		if @subscriptions[channel]?
			@subscriptions[channel].on "data", (data) ->
				onMessage data.message
			return Promise.resolve()

		return new Promise (resolve, reject) =>
			client = net.connect @port, @host, ->
				client.write { subscribe: channel }

			client.setEncoding "utf8"

			client.on "data", (data) ->
				if data.subscribe?
					@subscriptions[channel] = client
					resolve()
				else if data.error? then reject new Error data.error
				else onMessage data.message

			client.on "error", (err) ->
				client.end()
				reject err

			client.on "close", (hadError) =>
				@unsubscribe channel


	unsubscribe: (channel) ->
		new Promise (resolve, reject) ->
			client = @subscriptions[channel]
			if client?
				client.on "close", -> resolve()
				client.end()

				delete @subscriptions[channel]
			else resolve()

	sendRequest: (requestObject) ->
		new Promise (resolve, reject) ->
			client = net.connect @port, @host, ->
				client.write requestObject

			client.setEncoding "utf8"

			client.on "data", (data) ->
				client.end()

				if data.error?
					reject new Error data.error
				else
					resolve JSON.parse data

			client.on "error", (err) ->
				client.end()
				reject err
