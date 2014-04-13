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
      test.request.execute (response) =>
        try
          test.checker.check(response)
        catch e
          console.log e.message

        if test.then?
          @_doRun(test.then)
