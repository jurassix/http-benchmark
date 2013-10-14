async = require 'async'
https = require 'https'
http = require 'http'
_ = require 'underscore'
util = require 'util'
colors = require 'colors'

class HttpBenchmark

  defaults:
    concurrentThreads: 20
    requestsPerThread: 200
    request: 0
    response: 0
    thread: 1
    target: {}
    stats:
      statuses: {}
      min: 99999999999
      max: -1
      avg: -1
      count: 0
      rate: 0
      start: false

  constructor: ->
    @options = _.defaults arguments[0] or {}, @defaults
    @options.target.agent = false
    @options.http_get = http.get
    @options.http_get = https.get if @options.target.port is 443 or @options.target.protocol?.indexOf("https") > -1
    @options.stats.start = new Date().getTime()
    console.log @options
    console.log @logRequest
      status: 'status'
      response: '{response order}'
      request: '{request position}'
      clientTime: '{client time (ms)}'
      serverTime: '{server time (ms)}'

  seed: =>
    threads = []
    threads.push @createThread for x in [0...@options.concurrentThreads]
    async.parallel threads, (err, results) =>
      @logResults()

  createThread: (callback) =>
    _thread = new Number @options.thread
    requests = []
    requests.push @sendRequest for x in [0...@options.requestsPerThread]
    async.parallel requests, (err, results) =>
      callback()

  sendRequest: (callback) =>
    start = new Date().getTime()
    _request = _.clone ++@options.request
    _response = (response) =>
      @logAndUpdateStats response, start, _request
      callback()
    _error = (e) =>
      console.log "#{++@options.response}::#{e.message}"
      @updateStats 0, new Date().getTime() - start
      callback()
    @options.http_get(@options.target, _response).on 'error', _error

  logAndUpdateStats: (response, start, request) ->
    clientTime = new Date().getTime() - start
    @logRequest
      status: response.statusCode
      request: request
      response: ++@options.response
      clientTime: clientTime
      serverTime: @_getServerTime response
    @updateStats response.statusCode, clientTime

  _getServerTime: (response) ->
    return response.headers["x-response-time"]  if response.headers["x-response-time"]
    return Math.floor(response.headers["x-runtime"] * 1000)  if response.headers["x-runtime"]
    -1

  logResults: ->
    console.log "#{@options.target.host}#{@options.target.path or ''} stats:"
    @options.stats.total_time = new Date().getTime() - @options.stats.start
    console.log util.inspect @options.stats

  logRequest: (data) ->
    status_color = (if data.status is 200 then "green" else "red")
    output = util.format "[%s] %s /%s time: %s (%s)"
    , data.status.toString()[status_color]
    , data.response
    , data.request
    , data.clientTime.toString().blue
    , data.serverTime.toString().yellow
    console.log output

  updateStats: (status, time) ->
    @options.stats.statuses[status] = @options.stats.statuses[status] or 0
    @options.stats.statuses[status]++
    @options.stats.min = time if time < @options.stats.min
    @options.stats.max = time if time > @options.stats.max
    @options.stats.avg = (@options.stats.avg * @options.stats.count + time) / ++@options.stats.count
    @options.stats.rate = @options.stats.count / (new Date().getTime() - @options.stats.start) * 1000

exports.HttpBenchmark = HttpBenchmark
