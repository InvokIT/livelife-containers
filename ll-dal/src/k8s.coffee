K8sClient = require "node-kubernetes-client"
fs = require "fs"
log = require("log4js").getLogger "k8s"
_ = require "lodash"

try
	readToken = fs.readFileSync '/var/run/secrets/kubernetes.io/serviceaccount/token'
catch err
	readTokenError = err

k8sServiceAddress = process.env.KUBERNETES_SERVICE_HOST + ":" + process.env.KUBERNETES_SERVICE_PORT

client = if not readTokenError? then new K8sClient
	host: process.env.KUBERNETES_SERVICE_HOST + ":" + process.env.KUBERNETES_SERVICE_PORT
	protocol: 'https'
	version: 'v1'
	token: readToken

module.exports =
	getPodAddresses: (labelSelector) ->
		return new Promise (resolve, reject) ->
			if readTokenError? then reject readTokenError

			query = 
				fieldSelector: "status.podIP"
				labelSelector: labelSelector

			client.pods.get query, (err, podResult) ->
				if err? then reject err; return

				pods = podResult[0].items

				# Can not get label selectors to work, so filter the pods here
				pods = _.filter pods, (pod) ->
					podLabels = pod.metadata?.labels
					if not podLabels? then return false

					for k, v of labelSelector
						if podLabels[k] isnt v then return false
					return true

				# Extract IP addresses from pods
				addresses = []

				for pod in pods
					addresses.push ip if (ip = pod.status?.podIP)?

				resolve addresses