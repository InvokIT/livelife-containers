request = require "request"
log = require("log4js").getLogger "Requestor"

class Requestor
	constructor: (options) ->
		{ @apiPrefix, @version, @namespace, @token, @host } = options if options?

		@apiPrefix ?= "api"
		@version ?= "v1"
		@namespace ?= "default"

	doRequest: (method, collection, name, body, queryParameters) ->
		url = "https://#{@host}/#{@apiPrefix}/#{@version}/namespaces/#{@namespace}/#{collection}"
		if name? then url += "/#{name}"

		options = 
			uri: url
			method: method
			json: true
			body: body
			auth: bearer: @token
			qs: queryParameters

		log.debug "doRequest request options: #{JSON.stringify(options)}"

		return new Promise (resolve, reject) ->
			doRequest options, (err, response, body) ->
				if err? then reject err; return

				log.debug "request response: #{JSON.stringify(response)}"
				resolve body

	get: (collection, itemName) ->
		@doRequest "GET", collection, itemName

	find: (collection, labelSelector, fieldSelector) ->
		@doRequest "GET", collection, null, null, { labelSelector, fieldSelector } 

	create: (collection, data) ->
		@doRequest "POST", collection, null, data

	replace: (collection, itemName, data) ->
		@doRequest "PUT", collection, itemName, data