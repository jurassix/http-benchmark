
_             = require 'lodash'
Q             = require 'q'
RequestRunner = require './http-benchmark-request-runner'
Reporter      = require './http-benchmark-reporter'

class HttpBenchmark

  defaults: ->
    concurrentWorkers : 1
    requestsPerWorker : 1
    label             : undefined
    target            : undefined
    throttle          : 1000
    verbose           : true

  constructor: ->
    @initialize()
    @

  initialize: ->
    @options  = @defaults()
    @requests = []
    @reports  = []
    @cookieJar = []
    @

  get: (url) ->
    @requests.push
      method : 'GET'
      url    : url
    @

  post: (url, data, contentType = 'application/json; charset=UTF-8') ->
    if _.isObject data
      data = JSON.stringify data
    @requests.push
      method      : 'POST'
      url         : url
      data        : data
      contentType : contentType
    @

  cookie: (value) ->
    @cookieJar.push value
    @

  concurrency: (value = 1) ->
    @options.concurrentWorkers = value
    @

  actions: (value = 1) ->
    @options.requestsPerWorker = value
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
    console.log "Total requests in this scenario = #{@requests.length * @options.concurrentWorkers * @options.requestsPerWorker}"
    promises = []
    @requests.forEach (request) =>
      deferred = Q.defer()
      promises.push deferred.promise
      options = _.defaults request: request, cookieJar: @cookieJar, @options
      process = new RequestRunner options
      process.setReporter(new Reporter()) if @options.reporter
      callback = ->
        deferred.resolve process.getReporter().report()
      process.start callback
    Q.all(promises).done (reports) =>
      console.log reports
    @initialize()
    @

module.exports = HttpBenchmark
