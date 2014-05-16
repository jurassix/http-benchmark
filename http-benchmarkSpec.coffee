###
./node_modules/.bin/mocha --compilers coffee:coffee-script/register --require coffee-script http-benchmarkSpec.coffee
###
sinon = require 'sinon'
should = require('chai').should()
HttpRequestRunner = require('./http-benchmark-request-runner')

describe 'HttpRequestRunner', ->
  @timeout 10000

  beforeEach ->
    @concurrentWorkers = 10
    @requestsPerWorker = 20
    @httpRequestRunner = new HttpRequestRunner
      concurrentWorkers: @concurrentWorkers
      requestsPerWorker: @requestsPerWorker
      throttle: 0
      request: {}

  it 'should create the correct number of Workers', (done) ->
    spy = sinon.spy @httpRequestRunner, '_buildBatch'
    stub = sinon.stub @httpRequestRunner, '_sendRequest', (callback) -> callback()
    closure = =>
      spy.callCount.should.equal @requestsPerWorker
      spy.reset()
      done()
    @httpRequestRunner.start closure

  it 'should create the correct number of requests per Workers', (done) ->
    @timeout 2000
    stub = sinon.stub @httpRequestRunner, '_sendRequest', (callback) -> callback()
    @httpRequestRunner.options.concurrentWorkers = 1
    closure = =>
      stub.callCount.should.equal @requestsPerWorker
      stub.reset()
      done()
    @httpRequestRunner.start closure

  it 'should create the correct total requests', (done) ->
    @timeout 2000
    stub = sinon.stub @httpRequestRunner, '_sendRequest', (callback) -> callback()
    closure = =>
      stub.callCount.should.equal @concurrentWorkers * @requestsPerWorker
      stub.reset()
      done()
    @httpRequestRunner.start closure
