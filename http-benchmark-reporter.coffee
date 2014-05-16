
class Reporter

  defaults: ->
    statuses   : {}
    min        : 0
    max        : 0
    avg        : 0
    count      : 0
    rate       : 0
    start      : 0
    total_time : 0

  constructor: ->
    @options = @defaults()
    @options.start = new Date().getTime()
    @

  report: ->
    @options.total_time = new Date().getTime() - @options.start
    JSON.stringify @options

  update: (stats) ->
    @options.label = stats.url
    @options.statuses[stats.status] ?= 0
    @options.statuses[stats.status]++
    @options.min = stats.time if stats.time < @options.min or @options.min is 0
    @options.max = stats.time if stats.time > @options.max
    @options.avg = (@options.avg * @options.count + stats.time) / ++@options.count
    @options.rate = @options.count / (new Date().getTime() - @options.start) * 1000
    @

module.exports = Reporter
