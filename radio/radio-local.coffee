Promise = require "promise"
log = require("./log").getLogger "radio-local"

listeners = {}

class LocalRadio
	constructor: ->

	publish: (channel, msg) ->
		log.trace "entering publish { channel: #{channel}, msg: #{msg} }"

		log.info "publish { channel: #{channel}, msg: #{msg} }"
		if (list = listeners[channel])? then l(msg) for l in list

		return Promise.resolve()

	subscribe: (channel, listener) ->
		log.trace "entering subscribe { channel: #{channel}, listener: #{listener} }"

		listeners = listeners[channel] or @listeners[channel] = []

		listeners.push listener

		return Promise.resolve()

	unsubscribe: (channel, listener) ->
		log.trace "entering unsubscribe { channel: #{channel}, listener: #{listener} }"

		if (list = listeners[channel])?
			index = list.indexOf listener
			log.info "unsubscribe { channel: #{channel}, listener: #{listener}, removing at index #{index}"
			list.splice index, 1 if index > -1

		return Promise.resolve()

module.exports = LocalRadio