Http-Benchmark
=============

Scriptable Http performance Scenario utility for any webapp. Easily performance test backend API layers and client facing sites in parallel with development.

[![Nodei stats](https://nodei.co/npm/http-benchmark.png?downloads=true)](https://npmjs.org/package/http-benchmark)
[![NPM](https://nodei.co/npm-dl/http-benchmark.png)](https://npmjs.org/package/http-benchmark)

## Installation
    npm install http-benchmark


## __Benckmark Scenario Options__:

 - __get(url)__ - submits a http or https GET request for the specified URL
 - __post(url, data, contentType)__ - submits a http or https POST request for the specified URL and data. Data can be JSON or string. Content type is optional, defaults to _application/json; charset=UTF-8_
 - __concurrency(number)__ - number of threads to execute in parallel for each Request URL
 - __actions(number)__ - number of request each concurrent thread will make. Actions are executed in series.
 - __throttle(time)__ - number of milliseconds to wait between actions
 - __report(bool)__ - produces a basic statistics object explaining the outcome of each URL
 - __verbose(bool)__ - toggles realtime request logging
 - __start__ - starts the scenario

## GET Example:
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

## POST Example:

    Scenario = require 'http-benchmark'

    scenario = new Scenario()

    data =
      foo: 'bar'
      goo: 100

    scenario
      .post 'https://www.google.com/upload', data
      .post 'https://www.google.com/upload', 'foo=bar&goo=100', 'application/x-www-form-urlencoded; charset=UTF-8'
      .concurrency 10
      .actions 5
      .throttle 1000
      .report()
      .start()

## Chained Example:
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
 - Add cookie support
 - Expose full URI object to get and post
 - Add report collector to display reports when all scenarios are completed or to a file
 - Add domain option so http requests can shorten
 - Integrate reports with D3 to visualize scenarios
 - Other start commands: repeat(n), start(n), forever
