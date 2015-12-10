amqp = require "amqplib"
log = require("log4js").getLogger "AMQ"

PUBSUB_EXCHANGE_NAME = "PubSub Exchange"

PUBSUB_EXCHANGE_OPTIONS =
	durable: false
	autoDelete: false

PUBSUB_EXCHANGE_TYPE = "topic"

PUBSUB_QUEUE_OPTIONS =
	exclusive: true
	durable: false
	autoDelete: true

class AMQ
	constructor: (@url) ->

	publish: (key, message) ->
		if not key? then return Promise.reject new Error "No key defined."
		if not message? then return Promise.reject new Error "No message defined."

		return @_getChannel()
		.then (channel) ->
			channel.assertExchange PUBSUB_EXCHANGE_NAME, PUBSUB_EXCHANGE_TYPE, PUBSUB_EXCHANGE_OPTIONS

			channel.publish PUBSUB_EXCHANGE_NAME, key, @_createMessageBuffer message

			log.debug "publish(#{key}, #{message}): Message sent succesfully."
		.catch (err) ->
			log.error "publish(#{key}, #{message})", err

	subscribe: (keys, messageHandler, subscriptionToken = {}) ->
		if not keys? then return Promise.reject new Error "No keys defined."
		if not messageHandler? then return Promise.reject new Error "No messageHandler defined."		

		keys = [keys] if not Array.isArray keys

		return @_getChannel()
		.then (ch) =>
			onMessage = (msg) =>
				cancelled = not msg?

				if cancelled
					# If we was cancelled by the server, start re-subscribing
					log.warn "subscribe(#{keys}): Subscription was cancelled by server. Resubscribing..."
					@_resubscribe key, messageHandler
					return
				else
					log.debug "subscribe(#{keys}): Received message: #{JSON.stringify(msg)}"

					try
						key = msg.fields.routingKey
						msgContent = @_decodeMessageBuffer msg.content
						p = messageHandler key, msgContent

						# If the handler returns a Promise, then use that, otherwise just ack
						if p?.then?
							p.then -> ch.ack(msg)
							p.catch (err) ->
								log.warn "subscribe(#{keys}): Error in messageHandler", err
						else
							ch.ack(msg)
					catch err
						# Something happened, don't ack
						log.warn "subscribe(#{keys}): Error in messageHandler", err
						throw err

			ch.assertExchange PUBSUB_EXCHANGE_NAME, PUBSUB_EXCHANGE_TYPE, PUBSUB_EXCHANGE_OPTIONS

			ch.assertQueue "", PUBSUB_QUEUE_OPTIONS
			.then (r) =>
				queueName = r.queue

				ch.bindQueue queueName, PUBSUB_EXCHANGE_NAME, key for key in keys

				return ch.consume queueName, onMessage, exclusive: true, noAck: false
				.then (r) =>
					subscriptionToken.cancel = -> ch.cancel r.consumerTag
					return subscriptionToken

		.catch (err) ->
			log.error "subscribe(#{exchangeName}, fn)", err

	_resubscribe: (exchangeName, messageHandler, subscriptionToken) ->
		@subscribe exchangeName, messageHandler, subscriptionToken
		.then -> log.warn "Resubscribed to exchange '#{exchangeName}'."
		.catch (err) =>
			log.warn "Resubscription to exchange '#{exchangeName}' failed. Retrying..."
			timeoutToken = setTimeout (=> @_resubscribe exchangeName, messageHandler, subscriptionToken), 500
			subscriptionToken.cancel = -> clearTimeout timeoutToken

	_createMessageBuffer: (msgData) -> new Buffer JSON.stringify(msgData)

	_decodeMessageBuffer: (msgBuffer) -> JSON.parse msgBuffer.toString()

	_createConnection: ->
		amqpUrl = @url

		return amqp.connect amqpUrl
		.then (c) =>
			log.info "Connected to #{amqpUrl}"

			@_connection = c

			c.on "close", @_onConnectionClose.bind @
			c.on "error", @_onConnectionError.bind @
			c.on "blocked", @_onConnectionBlocked.bind @
			c.on "unblocked", @_onConnectionUnblocked.bind @

			return c
		.catch (err) ->
			log.error "Unable to connect to #{amqpUrl}", err

	_getConnection: ->
		if @_connection? then Promise.resolve @_connection else @_createConnection()

	_getChannel: ->
		return @_getConnection()
		.then (c) -> c.createChannel()
		.then (ch) ->
			ch.on "close", @_onChannelClose.bind @
			ch.on "error", @_onChannelError.bind @
			ch.on "return", @_onChannelReturn.bind @
			ch.on "drain", @_onChannelDrain.bind @
			return ch

	_onConnectionClose: ->
		log.info "Connection closed."
		@_connection = null

	_onConnectionError: (error) ->
		log.error "Connection error", err
		@_connection = null

	_onConnectionBlocked: (reason) ->
		log.warn "Connection blocked. Reason: #{reason}"

	_onConnectionUnblocked: ->
		log.warn "Connection unblocked."

	_onChannelClose: ->
		log.debug "Channel closed."

	_onChannelError: (error) ->
		log.error "Channel error.", error

	_onChannelReturn: (msg) ->
		log.warn "A message was returned to sender: #{msg}"

	_onChannelDrain: ->
		log.warn "A channel drain event was sent."

module.exports = AMQ