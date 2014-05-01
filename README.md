Http-Benchmark
=============

Scriptable Http Benchmarking util for node

Example usage:

    HttpBenchmark = require './http-benchmark.coffee'
    async = require 'async'

    domain            = 'www.google.com'
    concurrency       = 2
    requestsPerThread = 2

    options = (search) ->
      concurrentThreads : concurrency
      requestsPerThread : requestsPerThread
      label             : search
      throttle          : 1000
      verbose           : true
      target            :
        host     : domain
        port     : 443
        protocol : 'https:'
        hash     : "q=#{search}"

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
    ], (err, results) ->
      results.forEach (result) ->
        console.log result

Example result:

    {
      "requests": [
        {
          "status": 200,
          "time": 634
        },
        {
          "status": 200,
          "time": 465
        },
        {
          "status": 200,
          "time": 93
        },
        {
          "status": 200,
          "time": 130
        }
      ],
      "statuses": {
        "200": 4
      },
      "min": 0,
      "max": 634,
      "avg": 330.5,
      "count": 4,
      "rate": 1.4466546112115732,
      "start": 1398956774447,
      "total_time": 2765,
      "label": "apple"
    }
    {
      "requests": [
        {
          "status": 200,
          "time": 450
        },
        {
          "status": 200,
          "time": 454
        },
        {
          "status": 200,
          "time": 84
        },
        {
          "status": 200,
          "time": 81
        }
      ],
      "statuses": {
        "200": 4
      },
      "min": 0,
      "max": 454,
      "avg": 267.25,
      "count": 4,
      "rate": 1.5661707126076743,
      "start": 1398956774448,
      "total_time": 2554,
      "label": "banana"
    }
    {
      "requests": [
        {
          "status": 200,
          "time": 473
        },
        {
          "status": 200,
          "time": 478
        },
        {
          "status": 200,
          "time": 98
        },
        {
          "status": 200,
          "time": 99
        }
      ],
      "statuses": {
        "200": 4
      },
      "min": 0,
      "max": 478,
      "avg": 287,
      "count": 4,
      "rate": 1.5402387370042356,
      "start": 1398956774448,
      "total_time": 2597,
      "label": "orange"
    }
    {
      "requests": [
        {
          "status": 200,
          "time": 467
        },
        {
          "status": 200,
          "time": 477
        },
        {
          "status": 200,
          "time": 100
        },
        {
          "status": 200,
          "time": 112
        }
      ],
      "statuses": {
        "200": 4
      },
      "min": 0,
      "max": 477,
      "avg": 289,
      "count": 4,
      "rate": 1.5325670498084292,
      "start": 1398956774448,
      "total_time": 2610,
      "label": "grape"
    }
    {
      "requests": [
        {
          "status": 200,
          "time": 505
        },
        {
          "status": 200,
          "time": 494
        },
        {
          "status": 200,
          "time": 116
        },
        {
          "status": 200,
          "time": 177
        }
      ],
      "statuses": {
        "200": 4
      },
      "min": 0,
      "max": 505,
      "avg": 323,
      "count": 4,
      "rate": 1.4792899408284024,
      "start": 1398956774448,
      "total_time": 2704,
      "label": "pear"
    }
    {
      "requests": [
        {
          "status": 200,
          "time": 513
        },
        {
          "status": 200,
          "time": 509
        },
        {
          "status": 200,
          "time": 125
        },
        {
          "status": 200,
          "time": 143
        }
      ],
      "statuses": {
        "200": 4
      },
      "min": 0,
      "max": 513,
      "avg": 322.5,
      "count": 4,
      "rate": 1.4930944382232176,
      "start": 1398956774448,
      "total_time": 2679,
      "label": "tangerine"
    }
