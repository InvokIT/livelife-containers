expect = require("chai").expect
prepareDb = require "../../../src/mongo/db"

describe "LiveChannel", ->

	beforeEach ->
		this.db = prepareDb -> Promise.resolve [process.env.MONGO_ADDRESS]

	afterEach ->

	it "should be included in db.use", ->
		this.db.use (facades) ->
			expect(facades.LiveChannel).to.exist
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