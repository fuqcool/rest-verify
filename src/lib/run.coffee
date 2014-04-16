_ = require 'underscore'
report = require '../lib/report'

module.exports = (testcases) ->
  stats =
    successCount: 0
    failureCount: 0
    testcaseCount: testcases.length

  # run test cases one after one
  _.forEach testcases, (test, index) ->
    test.on 'complete', (info) ->
      stats.successCount += info.success
      stats.failureCount += info.failure

      if index isnt testcases.length - 1
        testcases[index + 1].run()
      else
        # report test stats
        report stats

        # if there exists failures, exit with error code 1
        if stats.failureCount isnt 0
          process.exit 1
        else
          process.exit 0

  testcases[0].run() if testcases.length
