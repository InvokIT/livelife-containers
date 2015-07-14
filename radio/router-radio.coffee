request = require("request").defaults json: true
express = require "express"
log = require("./log").getLogger "router-radio"

module.exports = (radio) ->
	router = express.Router()
	listeners = {}

	router.post "/subscribe", (req, res) ->
		channel = req.params.channel
		cbUrl = req.body

		# If the callback url is not absolute, use the requesters IP address to build an absolute http url
		if not /^[^:]+:\/\//.test cbUrl
			if /^[^:\/]/.test cbUrl then cbUrl = "/#{cbUrl}"
			cbIp = req.ip
			cbUrl = "http://#{cbIp}#{cbUrl}"

		if listeners[cbUrl]?
			log.warn "Tried to subscribe multiple times on channel '#{channel}' with url '#{cbUrl}'."
			return

		listener = (msg) ->
			request.post uri: cbUrl, body: msg, (err, httpMsg, response) ->
				if not err?
					log.debug "Message sent on channel '#{channel}' to url '#{cbUrl}', message: #{msg}."
				else
					log.warn "Tried to send message on channel '#{channel}'' to url '#{cbUrl}', message: #{msg}. Error: #{err}"

		listeners[cbUrl] = listener

		radio.subscribe channel, listener

		return

	router.post "/unsubscribe", (req, res) ->
		channel = req.params.channel
		cbUrl = req.body

		listener = listeners[cbUrl]

		if listener?
			delete listeners[cbUrl]
			radio.unsubscribe channel, listener

		return

	router.post "/:channel", (req, res) ->
		channel = req.params.channel
		message = req.body

		radio.publish channel, message

		return

	return router