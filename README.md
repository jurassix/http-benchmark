Http-Benchmark
=============

Scriptable Http performance Scenario utility for any webapp. Easily performance test backend API layers and client facing sites in parallel with development.

[![Nodei stats](https://nodei.co/npm/http-benchmark.png?downloads=true)](https://npmjs.org/package/http-benchmark)

## Installation
    npm install http-benchmark


## __Scenario Options__:

 - __get__ - submits a http or https get request for the specified URL
 - __concurrency__ - number of threads to execute in parallel for each Request URL
 - __actions__ - number of request each concurrent thread will make. Actions are executed in series.
 - __throttle__ - number of milliseconds to wait between actions
 - __report__ - produces a basic statistics object explaining the outcome of each URL
 - __verbose__ - toggles realtime request logging
 - __start__ - starts the scenario

## Simple Usage:
The below example will create 10 parallel threads. Each thread will execute 5 actions in series. The action will be a single Http request to Google. Each action will wait for the previous action to complete and then add a 1000ms delay before starting. A basic report will be displayed that shows statistics about the scenario as it playout out. A total of 50 requests will be made.

    Scenario = require 'http-benchmark'

    scenario = new Scenario()

    scenario
      .get 'https://www.google.com#q=apple'
      .concurrency 10
      .actions 5
      .throttle 1000
      .report()
      .start()

## Complex Usage:
We can also chain Scenario's together after _start_ is invoked. Each new scenario is given it's own option block, thread runner, and reporter. In the below example we execute 3 scenarios. The first scenario asks for 4 threads to each make 100 requests for the provided urls. The second scenario asks 4 threads to fork into 10 threads and each make 10 requests. The third and final scenario is similar to the second but with a higher delay between requests. Each scenario will generate a unique report. A total of 1200 requests will be made.

    Scenario = require 'http-benchmark'

    scenario = new Scenario()

    scenario
      .get 'https://www.google.com#q=apple'
      .get 'https://www.google.com#q=pear'
      .get 'https://www.google.com#q=banana'
      .get 'https://www.google.com#q=peach'
      .concurrency 1
      .actions 100
      .report()
      .start()
      .get 'https://www.google.com#q=orange'
      .get 'https://www.google.com#q=grape'
      .get 'https://www.google.com#q=alvocado'
      .get 'https://www.google.com#q=fig'
      .concurrency 10
      .actions 10
      .throttle 2000
      .report()
      .start()
      .get 'https://www.google.com#q=tangerine'
      .get 'https://www.google.com#q=kiwi'
      .get 'https://www.google.com#q=carrot'
      .get 'https://www.google.com#q=tomato'
      .concurrency 10
      .actions 10
      .throttle 3000
      .report()
      .start()

## Improvements
 - Add post support (in progress)
 - Add cookie support
 - Expose full URI object to get and post
 - Add report collector to display reports when all scenarios are completed or to a file
 - Add domain option so http requests can shorten
 - Integrate reports with D3 to visualize scenarios
 - Other start commands: repeat(n), start(n), forever

## Example:

    HttpBenchmark = require 'http-benchmark'

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

## Example result:

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

