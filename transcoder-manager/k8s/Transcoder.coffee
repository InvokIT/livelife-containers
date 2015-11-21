fs = require "fs"
K8sClient = require "node-kubernetes-client"
_ = require "lodash"
log = require("log4js").getLogger "k8s/Transcoder"

readToken = fs.readFileSync '/var/run/secrets/kubernetes.io/serviceaccount/token'

k8sServiceAddress = process.env.KUBERNETES_SERVICE_HOST + ":" + process.env.KUBERNETES_SERVICE_PORT

client = new K8sClient
	host: k8sServiceAddress
	protocol: 'https'
	version: 'v1'
	token: readToken

class Transcoder
	constructor: (@channelName, @format) ->

	@get: (channelName, format) ->
		return new Transcoder channelName, format

	getLabels: ->
		{ app: "transcoder", channel: @channelName, format: @format }

	getName: ->
		"transcoder-#{@format}-#{@channelName}"

	isRunning: ->
		return new Promise (resolve, reject) =>
			log.trace "Transcoder(@channelName, @format)::isRunning()"

			client.replicationControllers.getByName @getName(), (err, rcResult) ->
				if err? then reject err; return

				log.debug rcResult
				reject new Error "Not implemented"

	start: ->
		# Create a new replication controller
		log.trace "Transcoder(@channelName, @format)::start()"

		rcSpec = require "./transcoder-rc.json"
		rcSpec.metadata.name = @getName()

		# TODO Commands
		# Get rtmp server address
		rcSpec.spec.template.spec.containers[0].command = [""]

		labels = @getLabels()
		labelTargets = [rcSpec.metadata.labels, rcSpec.spec.selector, rcSpec.spec.template.metadata.labels]
		Object.assign t, labels for t in labelTargets

		return new Promise (resolve, reject) ->
			client.replicationControllers.create rcSpec, (err) ->
				if err? then reject err else resolve()

	stop: ->
		return new Promise (resolve, reject) ->
			# TODO Investigate that the Pod also gets deleted
			client.replicationControllers.delete @getName(), (err) ->
				if err? then reject err else resolve()

module.exports = Transcoder