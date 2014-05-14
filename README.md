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
 - __cookie(string)__ - cookie string to forward along with request header.
 - __concurrency(number)__ - number of workers to execute in parallel for each Request URL
 - __actions(number)__ - number of requests each concurrent worker will make. Actions are executed in throttled batches (see _throttle_)
 - __throttle(time)__ - number of milliseconds to wait between batch
 - __report(bool)__ - produces a basic statistics object explaining the outcome of each URL. _Currently experimental and not 100% functional (see #Improvements)_
 - __verbose(bool)__ - toggles realtime request logging
 - __start__ - starts the scenario

## FAQ:
When testing large number of concurrent requests you may experience issues related to native HTTP library limitations or OS limitations. Here are some symptoms and recommended fixes:
 - __Many of my requests are failing, the status codes are _0_. What is happening?__

 You are probably getting the following error: __{"0":{"code":"EMFILE","errno":"EMFILE","syscall":"connect"}}__

 Which basically means you have run out of available connections on your machine.

 If you are on a *nix box increase your _ulimit_ to a large number.

 _You can view your current open file limit with the following command, or Google 'ulimit' for more info._

 _> ulimit -u_

 - __My requests are taking too long with this tool, my server is serving the requests in _milliseconds_ but my response times are in _seconds_. What is happening?__

 You may encounter this _error_ with large numbers of concurrent requests over __HTTPS__. If you inspect your packet traffic you will see many seconds of time spent by Node's HTTPS module negotiating secure communication: Cipher exchange, etc.
 You can approach the issue in two distinct ways:
  - Prefer HTTP for large concurrency to HTTPS
  - Scale back the concurrency of your Scenario and scale horizontally using EC2 or other VM's to reach the same concurrency with HTTPS

## GET Example:
The below example will create 10 parallel workers. Each worker will execute 5 actions in batches delayed 1000ms. The action will be a single Http request to Google. Each action is non-blocking and will execute 1000ms apart. A basic report will be displayed that shows statistics about the scenario as it plays out. A total of 50 requests will be made.

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
      .cookie 'name=value;domain=.google.com;path=/;secure=true'
      .cookie 'another=value;domain=.example.com;path=/'
      .concurrency 10
      .actions 5
      .throttle 1000
      .report()
      .start()

## Chained Example:
To accurately performance test a web app you need to put the system under production like load. Typically you would want to spin up requests to all parts of your system in parallel to the new feature/service your testing. Chained scenarios are one answer to this problem. In the below example we chain Scenario's together to create tests that match real world load. Each new scenario is given a separate option block, worker, runner, and reporter. The first scenario produces 10,000 requests 10 per batch, each batch 10ms apart, to Google's main page 'www.google.com'. The second scenario exercises Google's search, 40 workers submitting 100 search requests with a 5s delay between request.

Since each scenario will execute simultaneously we can test the search components performance while the main system is being exercised too.

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
      .get 'https://www.google.com#q=avocado'
      .get 'https://www.google.com#q=fig'
      .concurrency 10
      .actions 100
      .throttle 5000
      .report()
      .start()

## Improvements
 - Fix Reporter - currently reporter is not tied to overal execution of requests and will report once all batches have completed, needs to wait till all requests are completed.
 - Add report collector to display reports when all scenarios are completed or to a file
 - Add domain option so http requests can shorten
 - Integrate reports with D3 to visualize scenarios
 - Other start commands: repeat(n), start(n), forever()


