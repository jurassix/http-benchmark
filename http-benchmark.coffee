https = require 'https'
http  = require 'http'
_     = require 'lodash'
RequestRunner = require './http-benchmark-request-runner'
Reporter = require './http-benchmark-reporter'

class HttpBenchmark

  defaults: ->
    concurrentThreads : 1
    requestsPerThread : 1
    label             : undefined
    target            : undefined
    throttle          : 0
    request           : 0
    response          : 0
    verbose           : true

  constructor: ->
    @initialize()
    @

  initialize: ->
    @options  = @defaults()
    @requests = []
    @reports  = []
    @

  get: (url) ->
    @requests.push
      method : 'GET'
      url    : url
    @

  post: (url, data) ->
    @requests.push
      method : 'POST'
      url    : url
      data   : data
    @

  concurrency: (value = 1) ->
    @options.concurrentThreads = value
    @

  actions: (value = 1) ->
    @options.requestsPerThread = value
    @

  throttle: (value = 1000) ->
    @options.throttle = value
    @

  verbose: (value = true) ->
    @options.verbose = value
    @

  report: (value = true) ->
    @options.reporter = value
    @

  start: =>
    console.log "Total requests in this scenario = #{@requests.length * @options.concurrentThreads * @options.requestsPerThread}"
    @requests.forEach (request) =>
      options = _.defaults request: request, @options
      process = new RequestRunner options
      process.setReporter(new Reporter()) if @options.reporter
      process.start()
    @initialize()
    @

module.exports = HttpBenchmark
