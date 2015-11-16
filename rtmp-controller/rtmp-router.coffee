express = require "express"
router = express.Router()
log = require("log4js").getLogger "rtmp-router"
dal = require "ll-dal"

getLocalIp = ->
	return new Promise (resolve, reject) ->
		hostname = require("os").hostname()
		require("dns").lookup hostname, family: 4, (err, address, family) ->
			if err? then reject err else resolve address

isLocalRelay = (req) ->
	req.body.flashver is "ngx-local-relay" and req.body.addr.startsWith "unix:"

onIngestPublish = (req, res) ->
	log.trace "onIngestPublish()"

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

	if channelExists and streamKeyIsValid
		# Set channel as live
		getLocalIp()
		.then (ip) ->
			dal.use (facades) ->
				facades.LiveChannel.save channelName, ip
		.then -> res.sendStatus 200
		.catch (err) ->
			log.error "onIngestUpdate: #{err}"
			res.sendStatus 500
	else
		res.sendStatus 403

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

module.exports = router