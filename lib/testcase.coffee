HttpRequest = require './http'
DataChecker = require './checker'
EventEmitter = require('events').EventEmitter

module.exports =
  class TestCase extends EventEmitter
    constructor: ->
      @request = new HttpRequest
      @checker = new DataChecker
      @then = null
      @successCount = 0
      @failureCount = 0

    run: () ->
      @_doRun(@)

    _doRun: (test) ->
      if test.auth?
        # if there is auth option, authenticate first
        test.auth.authenticate =>
          test.auth.beforeRequest test.request
          @_send test
      else
        @_send test

    _send: (test) ->
      test.request.execute (response) =>
        test.checker.on 'fail', (e) =>
          @failureCount++
          console.log ("""
          Fail: expect #{e.selector}:#{e.predicate} to be #{e.expectedValue}, actual: #{e.actualValue}
          """)

        test.checker.on 'success', =>
          @successCount++

        test.checker.check(response)

        if test.then?
          @_doRun(test.then)
        else
          stats =
            success: @successCount
            failure: @failureCount

          @emit 'complete', stats
