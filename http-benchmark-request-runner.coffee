
async  = require 'async'
url    = require 'url'
https  = require 'https'
http   = require 'http'
_      = require 'lodash'
colors = require 'colors'

class RequestRunner

  defaults: ->
    request           : {}
    concurrentWorkers : 1
    requestsPerWorker : 1
    throttle          : 0
    request           : 0
    response          : 0
    verbose           : true

  constructor: (options = {}) ->
    @options = _.defaults options, @defaults()
    @

  start: (callback) =>
    workers = []
    workers.push @_createTask for x in [0...@options.concurrentWorkers]
    async.parallel workers, (err, results) =>
      if @reporter
        @reporter.report callback

  setReporter: (@reporter) ->
    @

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

  _createTask: (callback) =>
    requests = []
    requests.push @_throttledSendRequest for x in [0...@options.requestsPerWorker]
    async.series requests, -> callback()

  _throttledSendRequest: (callback) =>
    _.delay @_sendRequest, @options.throttle, callback

  _sendRequest: (callback) =>
    start = new Date().getTime()
    _handlerCallback = (response) =>
      clientTime = new Date().getTime() - start
      _options =
        method : @options.request.method
        status : response.statusCode or 0
        url    : @options.request.url
        time   : clientTime
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
      console.log "#{stats.method.toUpperCase()} ".magenta + _status + " #{stats.time}ms".magenta + " #{stats.url}"

module.exports = RequestRunner
