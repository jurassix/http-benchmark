
async  = require 'async'
url    = require 'url'
https  = require 'https'
http   = require 'http'
_      = require 'lodash'
Q      = require 'q'
colors = require 'colors'

class RequestRunner

  defaults: ->
    request           : {}
    concurrentWorkers : 1
    requestsPerWorker : 1
    throttle          : 1000
    verbose           : true

  constructor: (options = {}) ->
    @options = _.defaults options, @defaults()
    @

  start: (done = ->) =>
    promises = []
    closure = (callback) =>
      deferred = Q.defer()
      promises.push deferred.promise
      @_buildBatch callback, deferred
    batches = []
    batches.push closure for x in [0...@options.requestsPerWorker]
    async.series batches, (err, results) ->
      Q.all(promises).done ->
        done()

  _buildBatch: (callback, deferred) =>
    workers = []
    workers.push @_sendRequest for x in [0...@options.concurrentWorkers]
    _.delay callback, @options.throttle
    async.parallel workers, (err, results) ->
      deferred.resolve()

  setReporter: (@reporter) ->
    @

  getReporter:  ->
    @reporter

  request: (callback) ->
    httpOptions = url.parse @options.request.url
    httpOptions.method = @options.request.method
    httpOptions.agent = false
    if @options.request.method is 'POST'
      httpOptions.headers =
        'Content-Length' : Buffer.byteLength @options.request.data
        'Content-Type'   : @options.request.contentType
        'Cookie'         : @options.cookieJar.join(';')
    else
      httpOptions.headers =
        'Cookie'         : @options.cookieJar.join(';')
    req = @_getHttpModule().request(httpOptions, callback).on 'error', callback
    if @options.request.method is 'POST'
      req.write @options.request.data
    req.end()

  _getHttpModule: ->
    if @_isHttps @options.request.url
      https
    else
      http

  _isHttps: (url) ->
    url.indexOf('443') > -1 or url.indexOf('https') > -1

  _sendRequest: (callback) =>
    start = new Date().getTime()
    _handlerCallback = (response) =>
      clientTime = new Date().getTime() - start
      _options =
        method : @options.request.method
        status : response.statusCode or 0
        url    : @options.request.url
        time   : clientTime
        start  : start
      @_logRequest _options
      if @reporter
        @reporter.update _options
      callback()
    @request _handlerCallback

  _logRequest: (stats) ->
    if @options.verbose
      if stats.status is 200
        _status = "#{stats.status}".green
      else
        _status = "#{stats.status}".red
      console.log "#{stats.start} ".blue + "#{stats.method.toUpperCase()} ".magenta + _status + " #{stats.time}ms".magenta + " #{stats.url}"

module.exports = RequestRunner
