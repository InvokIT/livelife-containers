expect = require("chai").expect
AMQ = require "../src/AMQ"

describe "AMQ", ->

	@timeout 5000

	beforeEach ->
		@amq = new AMQ process.env.AMQ_ADDRESS

	afterEach ->
		@amq.close()
		@amq = null

	describe "publish & subscribe", ->

		it "should publish messages with no subscriber", ->
			@amq.publish "test-key", "test-value"

		it "should publish messages to multiple subscribers", (done) ->
			count = 0
			subscriberCount = 10

			onMessage = (key, value) ->
				expect(key).to.be.equal "test-key"
				expect(value).to.be.equal "test-value"
				count += 1
				console.info "Message #{count} received"
				done() if count is subscriberCount

			Promise.all (@amq.subscribe "test-key", onMessage for n in [1..subscriberCount]) 
			.then => 
				console.info "Subscriptions ready, publishing."
				@amq.publish "test-key", "test-value"
			.catch (err) -> done err
			return

		it "should stop publishing to cancelled subscribers", () ->
			subscriberCount = 10
			subscriberCalled = (false for n in [1..subscriberCount])

			onMessage = (subscriber, key, value) ->
				expect(key).to.be.equal "test-key"
				expect(value).to.be.equal "test-value"
				subscriberCalled[subscriber] = true

			Promise.all (@amq.subscribe "test-key", onMessage.bind(@, n) for n in [0...subscriberCount])
			.then (subTokens) -> Promise.all (s.cancel() for s in subTokens[(subscriberCount / 2)..])
			.then => @amq.publish "test-key", "test-value"
			.then -> new Promise (resolve) -> setTimeout resolve, 500
			.then ->
				for v, i in subscriberCalled
					expect(v).to.be.equal (i < subscriberCount / 2)

		it "should publish to subscribers with key patterns"
