TestCase = require './testcase'

testcase = new TestCase()

testcase.request.path = '/home/fuqcool/blueos/rest/app'
testcase.request.hostname = 'net4.ccs.neu.edu'

testcase.checker.addPredicate(require './predicate/isArray.coffee')

testcase.run()
