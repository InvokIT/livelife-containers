express = require "express"
router = express.Router()
log = require("log4js").getLogger "rtmp-router"
dal = require "ll-dal"

onIngestPublish = (req, res) ->
	log.trace "onIngestPublish"

	onIngestUpdate req, res

onIngestPublishDone = (req, res) ->
	log.trace "onIngestPublishDone"

onIngestUpdate = (req, res) ->
	log.trace "onIngestUpdate"
	channelName = req.body.name
	streamKey = req.body.key

	# TODO Check if channel exists and the stream key is valid
	channelExists = true
	streamKeyIsValid = true

	if channelExists and streamKeyIsValid
		res.sendStatus 200

		# Set channel as live
		dal.LiveChannels
	else
		res.sendStatus 403

router.post "/publish", (req, res) ->
	log.trace "/publish"
	rtmpAppName = req.body.app
	switch rtmpAppName
		when "ingest" then onIngestPublish req, res
		else
			log.warn "/publish: Invalid rtmpAppName '#{rtmpAppName}'."
			res.sendStatus 422

router.post "/publish_done", (req, res) ->
	log.trace "/publish_done"
	rtmpAppName = req.body.app
	switch rtmpAppName
		when "ingest" then onIngestPublishDone req, res
		else
			log.warn "/publish_done: Invalid rtmpAppName '#{rtmpAppName}'."
			res.sendStatus 422

router.post "/update"
	log.trace "/update"
	rtmpAppName = req.body.app
	switch rtmpAppName
		when "ingest" then onIngestUpdate req, res
		else
			log.warn "/update: Invalid rtmpAppName '#{rtmpAppName}'."
			res.sendStatus 422

module.exports = router