express = require "express"
router = express.Router()
log = require("log4js").getLogger "rtmp-router"
dal = require "ll-dal"
promisify = require "node-promisify"
dns = require "dns"
os = require "os"

isLocalRelay = (req) ->
	req.body.flashver is "ngx-local-relay" and req.body.addr.startsWith "unix:"

getLocalIp = () ->
	promisify(dns.lookup) os.hostname()

onIngestPublish = (req, res) ->
	log.trace "onIngestPublish()"

	channelName = req.body.name

	# TODO Check if channel exists and the stream key is valid
	channelExists = true
	streamKeyIsValid = true

	if !channelExists or !streamKeyIsValid
		res.sendStatus 403
	else
		# If there's already someone publishing to this channel, deny
		dal.use (facades) ->
			facades.LiveChannel.getRtmpAddress channelName
			.then (address) ->
				if address? then res.sendStatus 409 #Conflict
		.then ->
			onIngestUpdate req, res

onIngestPublishDone = (req, res) ->
	channelName = req.body.name

	log.trace "onIngestPublishDone(channelName: #{channelName})"

	dal.use (facades) ->
		facades.LiveChannel.remove channelName
	.then res.sendStatus 200
	.catch (err) ->
		log.error "onIngestPublishDone: #{err}"

onIngestUpdate = (req, res) ->
	channelName = req.body.name
	streamKey = req.body.key

	log.trace "onIngestUpdate(channelName: #{channelName}, streamKey: #{streamKey})"

	# TODO Check if channel exists and the stream key is valid
	channelExists = true
	streamKeyIsValid = true

	if !channelExists or !streamKeyIsValid
		res.sendStatus 403
	else
		# Set channel as live
		getLocalIp()
		.then (ip) ->
			dal.use (facades) ->
				facades.LiveChannel.save channelName, ip
				.then -> log.info "#{channelName} rtmp address updated to #{ip}."
			.then -> res.sendStatus 200
			.catch (err) ->
				log.error "onIngestUpdate: #{err}"
				res.sendStatus 500

onIngestPlay = (req, res) ->
	channelName = req.body.name

	log.trace "onIngestPlay(channelName: #{channelName})"

	# Forward to the server that has this stream, if it is not this server.
	ip = req.ip
	dal.use (facades) ->
		facades.LiveChannel.getRtmpAddress channelName
		.then (rtmpAddress) ->
			if not rtmpAddress?
				res.sendStatus 404
			else if rtmpAddress is ip
				res.sendStatus 200
			else
				res.redirect 301, "rtmp://#{rtmpAddress}:1935/ingest/#{channelName}"

	.catch (err) ->
		log.error "onIngestPlay: #{err}"
		res.sendStatus 500

router.post "/publish", (req, res) ->
	log.trace "/publish"

	log.debug "/publish body: #{JSON.stringify(req.body)}"

	if isLocalRelay req then res.sendStatus 200; return

	rtmpAppName = req.body.app

	switch rtmpAppName
		when "ingest" then onIngestPublish req, res
		else
			log.warn "/publish: Invalid rtmpAppName '#{rtmpAppName}'."
			res.sendStatus 422

router.post "/publish_done", (req, res) ->
	log.trace "/publish_done"

	log.debug "/publish_done body: #{JSON.stringify(req.body)}"

	if isLocalRelay req then res.sendStatus 200; return

	rtmpAppName = req.body.app

	switch rtmpAppName
		when "ingest" then onIngestPublishDone req, res
		else
			log.warn "/publish_done: Invalid rtmpAppName '#{rtmpAppName}'."
			res.sendStatus 422

router.post "/update", (req, res) ->
	log.trace "/update"

	log.debug "/update: #{JSON.stringify(req.body)}"

	if isLocalRelay req then res.sendStatus 200; return

	rtmpAppName = req.body.app

	switch rtmpAppName
		when "ingest" then onIngestUpdate req, res
		else
			log.warn "/update: Invalid rtmpAppName '#{rtmpAppName}'."
			res.sendStatus 422

router.post "/play", (req, res) ->
	log.trace "/play"

	log.debug "/play: #{JSON.stringify(req.body)}"

	if isLocalRelay req then res.sendStatus 200; return

	switch rtmpAppName
		when "ingest" then onIngestPlay req, res
		else
			log.warn "/play: Invalid rtmpAppName '#{rtmpAppName}'."
			res.sendStatus 422


module.exports = router