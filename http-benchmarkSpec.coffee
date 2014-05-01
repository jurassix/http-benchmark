###
./node_modules/.bin/mocha --compilers coffee:coffee-script --require coffee-script http-benchmarkSpec.coffee
###
sinon = require 'sinon'
should = require('chai').should()
HttpBenchmark = require('./http-benchmark.coffee')

describe 'HttpBenchmark', ->

  beforeEach ->
    @concurrentThreads = 10
    @requestsPerThread = 20
    @httpBenchmark = new HttpBenchmark
      concurrentThreads: @concurrentThreads
      requestsPerThread: @requestsPerThread
      throttle: 0
      target: {}

  it 'should create the correct number of threads', ->
    spy = sinon.spy()
    @httpBenchmark._createThread = spy
    @httpBenchmark._sendRequest = sinon.stub()
    @httpBenchmark.start()
    spy.callCount.should.equal @concurrentThreads
    spy.reset()

  it 'should create the correct number of requests per threads', ->
    stub = sinon.stub()
    @httpBenchmark._throttledSendRequest = (callback) ->
      stub()
      callback()
    @httpBenchmark.options.concurrentThreads = 1
    @httpBenchmark.start()
    stub.callCount.should.equal @requestsPerThread

  it 'should create the correct total requests', ->
    stub = sinon.stub()
    @httpBenchmark._throttledSendRequest = (callback) ->
      stub()
      callback()
    @httpBenchmark.start()
    stub.callCount.should.equal @concurrentThreads * @requestsPerThread
