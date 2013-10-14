###
./node_modules/.bin/mocha --compilers coffee:coffee-script --require coffee-script HttpBenchmarkSpec.coffee
###
sinon = require 'sinon'
should = require('chai').should()
HttpBenchmark = require('./HttpBenchmark.coffee').HttpBenchmark

describe 'HttpBenchmark', ->

  beforeEach ->
    @httpBenchmark = new HttpBenchmark
      concurrentThreads: 10
      requestsPerThread: 20

  it 'should create the correct number of threads', (done) ->
    spy = sinon.spy()
    @httpBenchmark.createThread = spy
    @httpBenchmark.sendRequest = sinon.stub()
    @httpBenchmark.seed()
    spy.callCount.should.equal 10
    done()

  it 'should create the correct number of requests per threads', (done) ->
    stub = sinon.stub()
    @httpBenchmark.sendRequest = stub
    @httpBenchmark.seed()
    stub.callCount.should.equal 200
    done()
