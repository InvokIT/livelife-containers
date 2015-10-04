uuid = require "node-uuid"
request = require "request"
Promise = require "promise"

class Transcoder
	constructor: (@options) ->
		@uuid = uuid.v4()

	start: ->
		new Promise (resolve, reject) =>
			options =
				cluster: @options.cluster
				overrides:
					containerOverrides: [
						name: "transcoder"
						command: [
							@options.rtmpAddress
							@options.streamName
							@uuid
						]
					]
				startedBy: "transcoder-#{@uuid}"
				taskDefinition: "transcoderTask"

			request.post
				uri: awsUrl
				body: options
				json: true
				, (err, httpIncomingMessage, response) =>
					if err?
						reject err
						return

					if response.failures?.length > 0
						reject response.failures[0].reason
						return

					task = response.tasks[0]
					@taskArn = task.taskArn

					resolve()

	stop: ->
		new Promise (resolve, reject) =>
			if not @taskArn?
				reject new Error "Transcoder is not started."
				return

			request.post
				uri: awsUrl
				body: 
					cluster: @options.cluster
					task: @taskArn			
				, (err, httpIncomingMessage, response) =>
					if err?
						reject err
						return

					delete @taskArn
					resolve()


module.exports = Transcoder