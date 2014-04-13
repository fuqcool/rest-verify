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
        test.checker.on 'fail', (e) =>
          console.log """
            Fail: expect #{e.selector}:#{e.predicate} to be #{e.expectedValue}, actual: #{e.actualValue}
          """
        test.checker.on 'success', =>
          console.log 'success'

        test.checker.check(response)

        if test.then?
          @_doRun(test.then)
