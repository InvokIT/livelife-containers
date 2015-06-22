port = process.env.PORT or 2400
environment = process.env.NODE_ENV or "production"

Msgbus = 
	switch environment
		when "debug" then require "./msgbus-local"
		when "production" then require "./msgbus-redis"

Cache =
	switch environment
		when "debug" then require "./cache-local"
		when "production" then require "./cache-redis"

net = require "net"
log = require("./log").getLogger "server"
RadioChannel = require "./radio-channel"

log.debug "RadioChannel = #{JSON.stringify RadioChannel}"

server = net.createServer (c) ->
	log.info "client connected"

	radioChannel = new RadioChannel(c, new Msgbus, new Cache)

	c.on "end", ->
		log.info "client disconnected"

server.listen port, -> log.info "listening on port #{port}"

