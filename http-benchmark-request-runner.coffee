
async  = require 'async'
url    = require 'url'
https  = require 'https'
http   = require 'http'
_      = require 'lodash'
colors = require 'colors'

class RequestRunner

  defaults: ->
    request           : {}
    concurrentThreads : 1
    requestsPerThread : 1
    throttle          : 0
    request           : 0
    response          : 0
    verbose           : true

  constructor: (options = {}) ->
    @options = _.defaults options, @defaults()
    @

  start: (callback) =>
    threads = []
    threads.push @_createThread for x in [0...@options.concurrentThreads]
    async.parallel threads, (err, results) =>
      if @reporter
        @reporter.report callback

  setReporter: (@reporter) ->
    @

  _getHttp: ->
    switch @options.request.method
      when 'GET'
        if @_isHttps @options.request.url
          return https.get
        else
          return http.get
      when 'POST'
        if @_isHttps @options.request.url
          return https.post
        else
          return http.post

  _isHttps: (url) ->
    url.indexOf('443') > -1 or url.indexOf("https") > -1

  _createThread: (callback) =>
    requests = []
    requests.push @_throttledSendRequest for x in [0...@options.requestsPerThread]
    async.series requests, -> callback()

  _throttledSendRequest: (callback) =>
    _.delay @_sendRequest, @options.throttle, callback

  _sendRequest: (callback) =>
    start = new Date().getTime()
    _handler = (response) =>
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
    target = url.parse @options.request.url
    target.agent = false
    @_getHttp()(target, _handler).on 'error', _handler

  _logRequest: (stats) ->
    if @options.verbose
      if stats.status is 200
        _status = "#{stats.status}".green
      else
        _status = "#{stats.status}".red
      console.log "#{stats.method.toUpperCase()} ".magenta + _status + " #{stats.time}ms".magenta + " #{stats.url}"

module.exports = RequestRunner
