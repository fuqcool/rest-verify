HttpRequest = require './http'
DataChecker = require './checker'

module.exports =
  class TestCase
    constructor: ->
      @request = new HttpRequest
      @checker = new DataChecker
      @after = null

    run: () ->
      @_doRun(@)

    _doRun: (test) ->
      test.request.execute (data) =>
        @checker.check(data)

        if test.after?
          @_doRun(test.after)
