###
./node_modules/.bin/mocha --compilers coffee:coffee-script --require coffee-script http-benchmarkSpec.coffee
###
sinon = require 'sinon'
should = require('chai').should()
HttpRequestRunner = require('./http-benchmark-request-runner')

describe 'HttpRequestRunner', ->

  beforeEach ->
    @concurrentThreads = 10
    @requestsPerThread = 20
    @httpRequestRunner = new HttpRequestRunner
      concurrentThreads: @concurrentThreads
      requestsPerThread: @requestsPerThread
      throttle: 0
      request: ''

  it 'should create the correct number of threads', ->
    spy = sinon.spy()
    @httpRequestRunner._createThread = spy
    @httpRequestRunner._sendRequest = sinon.stub()
    @httpRequestRunner.start()
    spy.callCount.should.equal @concurrentThreads
    spy.reset()

  it 'should create the correct number of requests per threads', ->
    stub = sinon.stub()
    @httpRequestRunner._throttledSendRequest = (callback) ->
      stub()
      callback()
    @httpRequestRunner.options.concurrentThreads = 1
    @httpRequestRunner.start()
    stub.callCount.should.equal @requestsPerThread

  it 'should create the correct total requests', ->
    stub = sinon.stub()
    @httpRequestRunner._throttledSendRequest = (callback) ->
      stub()
      callback()
    @httpRequestRunner.start()
    stub.callCount.should.equal @concurrentThreads * @requestsPerThread
