Http-Benchmark
=============

Scriptable Http Benchmarking util for node

Example below will create 2 concurrent threads for each URL and make 3 requests in series each 1000ms a part.

Options:

    get - submits a http or https get request for the specified URL
    concurrency - number of threads to execute in parallel for each Request URL
    actions - number of request each concurrent thread will make. Actions are executed in series.
    throttle - number of miliseconds to wait between actions
    report - produces a basic statistics object explaining the outcome of each URL
    verbose - toggles realtime request logging
    start - starts the scenario

Example usage:

    HttpBenchmark = require './http-benchmark'

    scenario = new HttpBenchmark()

    scenario
      .get 'https://www.google.com#q=apple'
      .get 'https://www.google.com#q=banana'
      .get 'https://www.google.com#q=orange'
      .get 'https://www.google.com#q=grape'
      .get 'https://www.google.com#q=pear'
      .get 'https://www.google.com#q=tangerine'
      .concurrency 2
      .actions 3
      .throttle 1000
      .report()
      .start()

Example result:

    Total requests to send = 36
    GET 200 220ms https://www.google.com#q=pear
    GET 200 224ms https://www.google.com#q=tangerine
    GET 200 265ms https://www.google.com#q=apple
    GET 200 240ms https://www.google.com#q=orange
    GET 200 239ms https://www.google.com#q=grape
    GET 200 262ms https://www.google.com#q=apple
    GET 200 264ms https://www.google.com#q=banana
    GET 200 268ms https://www.google.com#q=tangerine
    GET 200 275ms https://www.google.com#q=pear
    GET 200 313ms https://www.google.com#q=grape
    GET 200 330ms https://www.google.com#q=banana
    GET 200 397ms https://www.google.com#q=orange
    GET 200 96ms https://www.google.com#q=pear
    GET 200 81ms https://www.google.com#q=grape
    GET 200 93ms https://www.google.com#q=orange
    GET 200 114ms https://www.google.com#q=apple
    GET 200 95ms https://www.google.com#q=pear
    GET 200 142ms https://www.google.com#q=tangerine
    GET 200 114ms https://www.google.com#q=grape
    GET 200 184ms https://www.google.com#q=apple
    GET 200 128ms https://www.google.com#q=banana
    GET 200 242ms https://www.google.com#q=tangerine
    GET 200 219ms https://www.google.com#q=banana
    GET 200 117ms https://www.google.com#q=orange
    GET 200 86ms https://www.google.com#q=orange
    GET 200 71ms https://www.google.com#q=apple
    GET 200 121ms https://www.google.com#q=grape
    GET 200 130ms https://www.google.com#q=pear
    GET 200 85ms https://www.google.com#q=pear
    {
      "statuses": {
        "200": 6
      },
      "min": 85,
      "max": 275,
      "avg": 150.16666666666666,
      "count": 6,
      "rate": 1.7196904557179709,
      "start": 1399054247587,
      "total_time": 3489,
      "label": "https://www.google.com#q=pear"
    }
    GET 200 121ms https://www.google.com#q=tangerine
    GET 200 123ms https://www.google.com#q=grape
    {
      "statuses": {
        "200": 6
      },
      "min": 81,
      "max": 313,
      "avg": 165.16666666666666,
      "count": 6,
      "rate": 1.6750418760469012,
      "start": 1399054247587,
      "total_time": 3582,
      "label": "https://www.google.com#q=grape"
    }
    GET 200 121ms https://www.google.com#q=apple
    {
      "statuses": {
        "200": 6
      },
      "min": 71,
      "max": 265,
      "avg": 169.5,
      "count": 6,
      "rate": 1.670378619153675,
      "start": 1399054247586,
      "total_time": 3592,
      "label": "https://www.google.com#q=apple"
    }
    GET 200 109ms https://www.google.com#q=banana
    GET 200 102ms https://www.google.com#q=tangerine
    {
      "statuses": {
        "200": 6
      },
      "min": 102,
      "max": 268,
      "avg": 183.16666666666666,
      "count": 6,
      "rate": 1.665741254858412,
      "start": 1399054247587,
      "total_time": 3602,
      "label": "https://www.google.com#q=tangerine"
    }
    GET 200 80ms https://www.google.com#q=orange
    {
      "statuses": {
        "200": 6
      },
      "min": 80,
      "max": 397,
      "avg": 168.83333333333334,
      "count": 6,
      "rate": 1.6542597187758479,
      "start": 1399054247587,
      "total_time": 3627,
      "label": "https://www.google.com#q=orange"
    }
    GET 200 133ms https://www.google.com#q=banana
    {
      "statuses": {
        "200": 6
      },
      "min": 109,
      "max": 330,
      "avg": 197.16666666666666,
      "count": 6,
      "rate": 1.6451878256100905,
      "start": 1399054247587,
      "total_time": 3647,
      "label": "https://www.google.com#q=banana"
    }
