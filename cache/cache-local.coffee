Promise = require "promise"
log = require("./log").getLogger "cache-local"

values = {}
deleters = {}

class Cache
	constructor: ->
		log.trace "< constructed"

	get: (key) ->
		log.trace "entering get { key: #{key} }"
		new Promise (resolve, reject) =>
			if key of values
				value = values[key]
				log.info "get { key: #{key}, value: #{value} }"
				resolve value
			else
				log.warn "Key does not exist: '#{key}'."
				reject new Error "Key does not exist."

	set: (key, value, options) ->
		log.trace "entering set { key: #{key}, value: #{value}, options: #{options} }"

		@remove(key).then =>
			new Promise (resolve, reject) =>
				values[key] = value

				if (ttl = options?.ttl)?
					deleters[key] = setTimeout (=> @remove key), ttl * 1000

				log.trace "exiting set { key: #{key}, value: #{value}, options: #{options} }"
				resolve()

	remove: (key) ->
		log.trace "entering remove { key: #{key} }"
		new Promise (resolve, reject) =>
			delete values[key]

			if key of deleters
				log.info "remove { key: #{key} }, also removing deleter"
				clearTimeout deleters[key]
				delete deleters[key]
			else
				log.info "remove { key: #{key} }"

			resolve()

module.exports = Cache