HttpRequest = require './http'
DataChecker = require './checker'

module.exports =
  class TestCase
    constructor: ->
      @request = new HttpRequest
      @checker = new DataChecker
      @then = null

    run: () ->
      @_doRun(@)

    _doRun: (test) ->
      test.request.execute (data) =>
        try
          test.checker.check(data)
        catch e
          console.log e.message

        debugger
        if test.then?
          @_doRun(test.then)
