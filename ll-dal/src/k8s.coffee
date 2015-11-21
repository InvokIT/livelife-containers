k8s = require("ll-k8s")()
log = require("log4js").getLogger "k8s"
_ = require "lodash"

module.exports =
	getPodAddresses: (labelSelector) ->
		return k8s("pods").find labelSelector
		.then (podResult) ->
			pods = podResult.items
			# Extract IP addresses from pods
			addresses = []

			for pod in pods
				addresses.push ip if (ip = pod.status?.podIP)?

			return addresses