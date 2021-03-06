Requestor = require "./Requestor"
Collection = require "./Collection"
fs = require "fs"

bearerToken = fs.readFileSync '/var/run/secrets/kubernetes.io/serviceaccount/token'
certificate = fs.readFileSync '/var/run/secrets/kubernetes.io/serviceaccount/ca.crt'

k8sHost = process.env.KUBERNETES_SERVICE_HOST + ":" + process.env.KUBERNETES_SERVICE_PORT

module.exports = create = (options = {}) ->
	options = Object.create options
	options.host ?= k8sHost
	options.token ?= bearerToken
	options.certificate ?= certificate

	requestor = new Requestor options

	return (collectionName) ->
		new Collection collectionName, requestor