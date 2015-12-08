k8s = require("ll-k8s")()
request = require "request"
path = require "path"
dns = require "dns"
os = require "os"
promisify = require "node-promisify"
log = require("log4js").getLogger "index"
_ = require "lodash"
rabbitmqctl = new (require "./rabbitmqctl") node: "rabbit@#{os.hostname()}"

# What does this sidecar do?
# At bootup:
#	* Join the cluster
# 	* Set queue policies for high-availability
# then every <INTERVAL> seconds:
#	* Get a list of pods running rabbitmq
#	* Ensure that this pod is in the cluster
#	* Remove any pods that are not running but still reported as part of the cluster

WORKER_INTERVAL = process.env.WORKER_INTERVAL or 30
POD_LABELSELECTOR = process.env.POD_LABELSELECTOR or "app=rabbitmq"
RABBIT_MANAGEMENT_URL = process.env.RABBIT_MANAGEMENT_URL || "http://localhost:15672/api/"

getAddressOfPods = ->
	k8s("pods").find(POD_LABELSELECTOR)
	.then (result) ->
		_.chain result.items
		.filter (p) -> p.metadata?.status?.podIP?
		.map (p) -> p.metadata.status.podIP
		.value()

getOwnAddress = ->
	promisify(dns.lookup) os.hostname()

setHaPolicy = ->
	defaultVHost = "%2f"

	return new Promise (resolve, reject) ->
		policyUrl = path.join RABBIT_MANAGEMENT_URL, "policies", defaultVHost, "ha-all"

		options = 
			method: "PUT"
			uri: policyUrl
			body:
				"pattern": ""
				"definition": "ha-mode": "all"
				"priority": 0
				"apply-to": "all"
			json: yes

		request options, (err, response, body) ->
			if err?
				log.error "setHaPolicy(): Error", err
				reject err
			else if response.statusCode >= 400
				err = new Error response.statusCode + ": " + response.statusMessage
				log.error "setHaPolicy(): Unexpected statusCode", err
				reject err
			else
				log.info "setHaPolicyPolicy(): ha-mode set to all"
				resolve body

ensurePodInCluster = (pods) ->
	getOwnAddress.then (thisPod) ->
		clusterStatus = rabbitmqctl.cluster_status()


removeDeadPodsInCluster = (pods) ->
	Promise.resolve()

worker = ->

	startWorker = -> setTimeout worker, WORKER_INTERVAL * 1000

	getAddressOfPods()
	.then (pods) ->
		logs.debug "RabbitMQ pod addresses: #{JSON.stringify(pods)}"
		Promise.all [
			ensurePodInCluster(pods)
			removeDeadPodsInCluster(pods)
		]
	.then startWorker
	.catch startWorker

module.exports =
	start: ->
		rabbitmqctl.wait() # Waits synchronously for RabbitMQ to boot

		joinCluster()
		setHaPolicy().then -> setImmediate worker
