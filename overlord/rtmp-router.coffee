express = require "express"
router = express.Router()

logger = require("./log").getLogger "rtmp"

onIngestPublish = (req, res) ->
	logger.trace "onIngestPublish"

	onIngestUpdate req, res

onIngestPublishDone = (req, res) ->
	logger.trace "onIngestPublishDone"

onIngestUpdate = (req, res) ->
	channelName = req.body.name
	streamKey = req.body.key

	# TODO Check if channel exists and the stream key is valid
	channelExists = true
	streamKeyIsValid = true

	if channelExists and streamKeyIsValid
		res.sendStatus 200
	else
		res.sendStatus 403

router.post "/publish", (req, res) ->
	logger.trace "/publish"
	rtmpAppName = req.body.app
	switch rtmpAppName
		when "ingest" then onIngestPublish req, res
		else
			logger.warn "/publish: Invalid rtmpAppName '#{rtmpAppName}'."
			res.sendStatus 422

router.post "/publish_done", (req, res) ->
	logger.trace "/publish_done"
	rtmpAppName = req.body.app
	switch rtmpAppName
		when "ingest" then onIngestPublishDone req, res
		else
			logger.warn "/publish_done: Invalid rtmpAppName '#{rtmpAppName}'."
			res.sendStatus 422

router.post "/update"
	logger.trace "/update"
	rtmpAppName = req.body.app
	switch rtmpAppName
		when "ingest" then onIngestUpdate req, res
		else
			logger.warn "/update: Invalid rtmpAppName '#{rtmpAppName}'."
			res.sendStatus 422

module.exports = router