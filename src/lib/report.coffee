logger = require './logger'

module.exports = (stats) ->
  # print report when last testcase completes
  if stats.failureCount isnt 0
    print = logger.red
  else
    print = logger.green

  print """
    #{stats.testcaseCount} testcases, #{stats.successCount + stats.failureCount} assertions, #{stats.successCount} success, #{stats.failureCount} failures.
  """
