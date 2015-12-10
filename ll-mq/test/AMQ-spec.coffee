expect = require("chai").expect
AMQ = require "../src/AMQ"

define "AMQ", ->

	beforeEach ->
		@amq = new AMQ process.env.AMQ_ADDRESS

	define "publish & subscribe", ->

		it "should publish messages with no subscriber", ->
			@mq.send "test-q", "test-m"

		it "should publish messages to multiple subscribers", (done) ->
			@mq.listen "test-q", (msg) ->
				expect(msg).to.be.equal "test-m"
				done()

			@mq.send "test-q", "test-m"

		it "should stop publishing to cancelled subscribers", ->

		it "should publish to subscribers with key patterns", ->