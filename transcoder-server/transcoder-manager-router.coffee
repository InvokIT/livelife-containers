express = require "express"

createRouter = (transcoderManager) ->
	router = express.Router()

	router.post "/:streamName/:format/start", (req, res) ->
		streamName = req.params.streamName
		format = req.params.format

		transcoderManager.start(streamName, format).then -> res.sendStatus 201, res.sendStatus 500

	router.post "/:streamName/:format/stop", (req, res) ->
		streamName = req.params.streamName
		format = req.params.format

		transcoderManager.stop(streamName, format).then -> res.sendStatus 204, res.sendStatus 500

	router.get "/stat", (req, res) ->
		res.status(200).send transcoderManager.statistics()

module.exports = create: createRouter