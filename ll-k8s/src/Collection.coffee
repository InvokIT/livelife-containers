
class Collection
	constructor: (@collectionName, @requestor) ->

	get: (itemName) ->
		@requestor.get @collectionName, itemName

	find: (labelSelector, fieldSelector) ->
		@requestor.find @collectionName, labelSelector, fieldSelector

	create: (data) ->
		@requestor.create @collectionName, data

	replace: (itemName, data) ->
		@requestor.replace @collectionName, itemName, data

	custom: (method, collection, itemName, body, queryParams) ->
		@requestor.doRequest method, collection, itemName, body, queryParams

module.exports = Collection