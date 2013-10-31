HttpBenchmark
=============

Scriptable Http Benchmarking util for node

Example usage:


    HttpBenchmark = require('../../HttpBenchmark/HttpBenchmark.coffee').HttpBenchmark
    async = require 'async'

    domain = 'www.google.com'
    verbose = true

    concurrency = 10
    requestsPerThread = 10

    options = (search) ->
      concurrentThreads: concurrency
      requestsPerThread: requestsPerThread
      label: page 
      target:
        host: domain
        port: 443
        protocol: 'https:'
        path: "/#q={search}"

    async.parallel [
      (callback) ->
        new HttpBenchmark(options 'apple').start callback
    ,
      (callback) ->
        new HttpBenchmark(options 'banana').start callback
    ,
      (callback) ->
        new HttpBenchmark(options 'orange').start callback
    ,
      (callback) ->
        new HttpBenchmark(options 'grape').start callback
    ,
      (callback) ->
        new HttpBenchmark(options 'pear').start callback
    ,
      (callback) ->
        new HttpBenchmark(options 'tangerine').start callback
    ], (err, result) ->
      console.log JSON.stringify result, null, '\t'
