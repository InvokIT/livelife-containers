expect = require("chai").expect
prepareDb = require "../../../src/mongo/db"

require("mongoose").set "debug", process.env.NODE_ENV isnt "production"

describe "LiveChannel", ->

	this.timeout 10000

	beforeEach ->
		this.db = prepareDb "localhost"

	afterEach ->

	it "should be included in db.use", ->
		this.db.use (models) ->
			expect(models.LiveChannel).to.exist
			return Promise.resolve()

	describe "save", ->
		it "should save channelName and rtmpAddress", ->
			this.db.use (facades) ->
				facades.LiveChannel.save "testChannel", "testRtmpAddress"
				.then ->
					facades.LiveChannel.findRtmpAddress "testChannel"
					.then (rtmpAddress) -> expect(rtmpAddress).to.be.equal "testRtmpAddress"

	describe "findRtmpAddress", ->
		it "should return null when channelName is not in the collection", ->
			this.db.use (facades) ->
				facades.LiveChannel.findRtmpAddress "nonexistingChannel"
				.then (rtmpAddress) -> expect(rtmpAddress).to.be.null