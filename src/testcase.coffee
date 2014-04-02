HttpRequest = require './http'
DataChecker = require './checker'

module.exports =
  class TestCase
    constructor: ->
      @request = new HttpRequest
      @checker = new ResponseChecker
      @after = null

    run: (case) ->
      case.request.execute (data) ->
        checker.check(data)

        if case.after?
          @run(case.after)
