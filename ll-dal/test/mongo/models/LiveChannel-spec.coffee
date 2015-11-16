expect = require("chai").expect
prepareDb = require "../../../src/mongo/db"

describe "LiveChannel", ->

	beforeEach ->
		this.db = prepareDb "localhost"

	afterEach ->

	it "should be included in db.use", ->
		this.db.use (models) ->
			expect(models.LiveChannel).to.exist
			return Promise.resolve()

	describe "save & findRtmpAddress", ->
		it "should save channelName and rtmpAddress and read it back", ->
			this.db.use (models) ->
				models.LiveChannel.save "testChannel", "testRtmpAddress"
				.then ->
					models.LiveChannel.findRtmpAddress "testChannel"
					.then (d) -> expect(d.rtmpAddress).to.be.equal "testRtmpAddress"
