
async = require 'async'
https = require 'https'
http  = require 'http'
_     = require 'lodash'

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
    stats             :
      requests : []
      statuses : {}
      min      : 0
      max      : 0
      avg      : 0
      count    : 0
      rate     : 0
      start    : 0

  constructor: (options = {}) ->
    @options = _.defaults options, @defaults()
    @_validateOptions()
    @_initialize()

  start: (callback) =>
    threads = []
    threads.push @_createThread for x in [0...@options.concurrentThreads]
    async.parallel threads, (err, results) =>
      @options.stats.total_time = new Date().getTime() - @options.stats.start
      @options.stats.label = @options.label if @options.label
      _stats = JSON.stringify @options.stats, null, '\t'
      if _.isFunction(callback) then callback(err, _stats) else _stats

  _validateOptions: ->
    unless @options.target?
      throw new Error "Please provide a target object @see require('url')"

  _initialize: ->
    @options.target.agent = false
    if @_isHttps()
      @options.http_get = https.get
    else
      @options.http_get = http.get
    @options.stats.start = new Date().getTime()

  _isHttps: ->
    @options.target.port is 443 or @options.target.protocol?.indexOf("https") > -1

  _createThread: (callback) =>
    requests = []
    requests.push @_throttledSendRequest for x in [0...@options.requestsPerThread]
    async.series requests, -> callback()

  _throttledSendRequest: (callback) =>
    _.delay @_sendRequest, @options.throttle, callback

  _sendRequest: (callback) =>
    start = new Date().getTime()
    requestOrder = @options.request++
    _response = (response) =>
      responseOrder = @options.response++
      clientTime = new Date().getTime() - start
      @_updateStats response.statusCode, clientTime, requestOrder
      callback()
    _error = =>
      clientTime = new Date().getTime() - start
      @_updateStats 0, clientTime, requestOrder
      callback()
    @options.http_get(@options.target, _response).on 'error', _error

  _updateStats: (status, time, requestOrder) ->
    if @options.verbose
      @options.stats.requests[requestOrder] =
        status: status
        time: time
    @options.stats.statuses[status] ?= 0
    @options.stats.statuses[status]++
    @options.stats.min = time if time < @options.stats.min
    @options.stats.max = time if time > @options.stats.max
    @options.stats.avg = (@options.stats.avg * @options.stats.count + time) / ++@options.stats.count
    @options.stats.rate = @options.stats.count / (new Date().getTime() - @options.stats.start) * 1000

module.exports = HttpBenchmark
