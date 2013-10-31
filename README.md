HttpBenchmark
=============

Scriptable Http Benchmarking util for node

Example usage:


    HttpBenchmark = require('../../HttpBenchmark/HttpBenchmark.coffee').HttpBenchmark
    async = require 'async'

    domain = 'www.google.com'

    concurrency = 2
    requestsPerThread = 2

    options = (search) ->
      concurrentThreads: concurrency
      requestsPerThread: requestsPerThread
      label: search
      target:
        host: domain
        port: 443
        protocol: 'https:'
        hash: "q=#{search}"

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


Example result:

    [
      {
        "requests": [
          {
            "status": 200,
            "time": 101
          },
          {
            "status": 200,
            "time": 84
          },
          {
            "status": 200,
            "time": 99
          },
          {
            "status": 200,
            "time": 107
          }
        ],
        "statuses": {
          "200": 4
        },
        "min": 84,
        "max": 107,
        "avg": 97.75,
        "count": 4,
        "rate": 18.51851851851852,
        "start": 1383224178355,
        "total_time": 216,
        "label": "apple"
      },
      {
        "requests": [
          {
            "status": 200,
            "time": 69
          },
          {
            "status": 200,
            "time": 85
          },
          {
            "status": 200,
            "time": 88
          },
          {
            "status": 200,
            "time": 112
          }
        ],
        "statuses": {
          "200": 4
        },
        "min": 69,
        "max": 112,
        "avg": 88.5,
        "count": 4,
        "rate": 22.099447513812155,
        "start": 1383224178382,
        "total_time": 181,
        "label": "banana"
      },
      {
        "requests": [
          {
            "status": 200,
            "time": 68
          },
          {
            "status": 200,
            "time": 72
          },
          {
            "status": 200,
            "time": 101
          },
          {
            "status": 200,
            "time": 139
          }
        ],
        "statuses": {
          "200": 4
        },
        "min": 68,
        "max": 139,
        "avg": 95,
        "count": 4,
        "rate": 19.32367149758454,
        "start": 1383224178382,
        "total_time": 207,
        "label": "orange"
      },
      {
        "requests": [
          {
            "status": 200,
            "time": 69
          },
          {
            "status": 200,
            "time": 72
          },
          {
            "status": 200,
            "time": 99
          },
          {
            "status": 200,
            "time": 97
          }
        ],
        "statuses": {
          "200": 4
        },
        "min": 69,
        "max": 99,
        "avg": 84.25,
        "count": 4,
        "rate": 23.668639053254438,
        "start": 1383224178384,
        "total_time": 169,
        "label": "grape"
      },
      {
        "requests": [
          {
            "status": 200,
            "time": 68
          },
          {
            "status": 200,
            "time": 91
          },
          {
            "status": 200,
            "time": 101
          },
          {
            "status": 200,
            "time": 85
          }
        ],
        "statuses": {
          "200": 4
        },
        "min": 68,
        "max": 101,
        "avg": 86.25,
        "count": 4,
        "rate": 22.727272727272727,
        "start": 1383224178384,
        "total_time": 176,
        "label": "pear"
      },
      {
        "requests": [
          {
            "status": 200,
            "time": 74
          },
          {
            "status": 200,
            "time": 97
          },
          {
            "status": 200,
            "time": 99
          },
          {
            "status": 200,
            "time": 77
          }
        ],
        "statuses": {
          "200": 4
        },
        "min": 74,
        "max": 99,
        "avg": 86.75,
        "count": 4,
        "rate": 22.988505747126435,
        "start": 1383224178385,
        "total_time": 174,
        "label": "tangerine"
      }
    ]
