async = require 'async'
https = require 'https'
http = require 'http'
_ = require 'underscore'
util = require 'util'

class HttpBenchmark

  defaults:
    concurrentThreads: 20
    requestsPerThread: 200
    request: 0
    response: 0
    thread: 1
    target: null

  stats:
    requests: null
    statuses: null
    min: 99999999999
    max: -1
    avg: -1
    count: 0
    rate: 0
    start: 0

  constructor: ->
    @options = _.defaults arguments[0] or {}, _.clone @defaults
    return if not @options.target?
    @options.target.agent = false
    @options.http_get = http.get
    @options.http_get = https.get if @options.target.port is 443 or @options.target.protocol?.indexOf("https") > -1
    @options.stats = _.clone @stats
    @options.stats.statuses = {}
    @options.stats.requests = []
    @options.stats.start = new Date().getTime()

  start: (callback) =>
    threads = []
    threads.push @createThread for x in [0...@options.concurrentThreads]
    async.parallel threads, (err, results) =>
      @options.stats.total_time = new Date().getTime() - @options.stats.start
      @options.stats.label = @options.label if @options.label
      _stats = _.clone @options.stats
      if typeof callback == "function" then callback(err, _stats) else _stats

  createThread: (callback) =>
    requests = []
    requests.push @sendRequest for x in [0...@options.requestsPerThread]
    async.series requests, -> callback()

  sendRequest: (callback) =>
    start = new Date().getTime()
    @options.request++
    _response = (response) =>
      @options.response++
      clientTime = new Date().getTime() - start
      @updateStats response.statusCode, clientTime
      callback()
    _error = (e) =>
      clientTime = new Date().getTime() - start
      @updateStats 0, clientTime
      callback()
    @options.http_get(@options.target, _response).on 'error', _error

  _getServerTime: (response) ->
    return response.headers["x-response-time"]  if response.headers["x-response-time"]
    return Math.floor(response.headers["x-runtime"] * 1000)  if response.headers["x-runtime"]
    -1

  updateStats: (status, time) ->
    @options.stats.requests.push
      status: status
      time: time
    @options.stats.statuses[status] = @options.stats.statuses[status] or 0
    @options.stats.statuses[status]++
    @options.stats.min = time if time < @options.stats.min
    @options.stats.max = time if time > @options.stats.max
    @options.stats.avg = (@options.stats.avg * @options.stats.count + time) / ++@options.stats.count
    @options.stats.rate = @options.stats.count / (new Date().getTime() - @options.stats.start) * 1000

exports.HttpBenchmark = HttpBenchmark
