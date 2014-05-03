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
We can also chain Scenario's together to create tests that can match real world load. Each new scenario is given it's own option block, thread runner, and reporter. The below scenario produces high request traffic, 10,000 requests each 10ms apart, to Google's main page 'www.google.com'. The second scenario exercises search load to Google, 40 threads submitting 100 search requests actions with a 5s delay between action.

Since each scenario will execute simultaneously we can test the search component while the rest of the system is being exercised too.

    Scenario = require 'http-benchmark'

    scenario = new Scenario()

    scenario
      .get 'https://www.google.com'
      .concurrency 10
      .actions 1000
      .throttle 10
      .report()
      .start()
      .get 'https://www.google.com#q=orange'
      .get 'https://www.google.com#q=grape'
      .get 'https://www.google.com#q=alvocado'
      .get 'https://www.google.com#q=fig'
      .concurrency 10
      .actions 100
      .throttle 5000
      .report()
      .start()

## Improvements
 - Add cookie support
 - Expose full URI object to get and post
 - Add report collector to display reports when all scenarios are completed or to a file
 - Add domain option so http requests can shorten
 - Integrate reports with D3 to visualize scenarios
 - Other start commands: repeat(n), start(n), forever

