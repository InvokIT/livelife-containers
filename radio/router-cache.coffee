express = require "express"
log = require "./log"

module.exports = (cache) ->
	router = express.Router()

	router.route "/cache/:key([^\/]){1,}"

	.put (req, res) ->
		key = req.params.join ""
		value = req.body
		ttl = parseInt req.header "X-TTL"
		overwrite = req.header("X-Overwrite") or true


		cache.set(key, value, ttl, overwrite).then
			->
				log.info "set success { key: #{key}, value: #{value}, ttl: #{ttl}, overwrite: #{overwrite} }"
				res.sendStatus 204
			(err) ->
				log.warn "set error { key: #{key}, value: #{value}, ttl: #{ttl}, overwrite: #{overwrite} }, #{err.msg}"
				res.status(403).send(err.msg)

		return

	.get (req, res) ->
		key = req.params.key
		
		cache.get(key).then
			(value) ->
				log.info "get success { key: #{key}, value: #{value} }"
				res.send value
			(err) ->
				log.warn "get error { key: #{key}, value: #{value} }, #{err.msg}"
				res.status(404).send(err.msg)

		return

	return router