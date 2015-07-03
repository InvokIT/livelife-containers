express = require "express"
log = require("./log").getLogger "router-cache"

module.exports = (cache) ->
	router = express.Router()

	router.route "/:key"

	.put (req, res) ->
		key = req.params.key
		value = req.body

		try
			ttl = parseInt ttlHeader if (ttlHeader = req.header "X-TTL")?
		catch error
			log.warn "Invalid X-TTL header value: '#{ttl}'. Error: #{error.message}"
			res.status(422).send error.message

		cache.set key, value, { ttl }
		.then ->
			log.info "set success { key: #{key}, value: #{value}, ttl: #{ttl} }"
			res.sendStatus 204
		, (err) ->
			log.warn "set error { key: #{key}, value: #{value}, ttl: #{ttl} }, #{err.message}"
			res.status(500).send err.message

		return

	.get (req, res) ->
		key = req.params.key
		
		cache.get key
		.then (value) ->
			log.info "get success { key: #{key}, value: #{value} }"
			res.send value
		, (err) ->
			log.warn "get error { key: #{key} }, #{err.message}"
			res.status(404).send err.message

		return

	.delete (req, res) ->
		key = req.params.key

		cache.remove key
		.then ->
			log.info "delete success { key: #{key} }"
			res.sendStatus 204
		, (err) ->
			log.warn "delete error { key #{key} }, #{err.message}"
			res.status(500).send err.message

		return

	return router