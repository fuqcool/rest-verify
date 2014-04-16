Testcase = require '../src/lib/testcase'

xdescribe 'testcase', ->
  testcase = null

  beforeEach ->
    testcase = parser.parse content.toString()

  it 'should parse request', ->
    expect(testcase.request.hostname).toBe 'http://net4.ccs.neu.edu/'
    expect(testcase.request.path).toBe '/home/fuqcool/blueos/rest/config'
    expect(testcase.request.method).toBe 'get'

  it 'should check data', ->
    spyOn(testcase.request, 'execute').andCallFake (cb) ->
      cb ['a', 'b', 'c']

    spyOn(testcase.checker, 'check')

    testcase.run()
    expect(testcase.checker.check).toHaveBeenCalled()
