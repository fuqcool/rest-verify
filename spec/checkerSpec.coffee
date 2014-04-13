DataChecker = require '../lib/checker'

describe 'Data checker', ->
  checker = null
  data = null
  pIs = jasmine.createSpy('is').andCallFake (v) -> v
  successCallback = null
  failCallback = null

  beforeEach ->
    successCallback = jasmine.createSpy 'success'
    failCallback = jasmine.createSpy 'fail'

    checker = new DataChecker
    checker.on 'success', successCallback
    checker.on 'fail', failCallback

    data =
      foo: 'bar'
      len: 100

  it 'should use equal as predicate when predicate is not specified', ->
    checker.addPredicate 'foo', 'bar'
    checker.check data

    expect(successCallback).toHaveBeenCalled()

  it 'should take predicate', ->
    checker.addPredicate 'foo', 'bar', pIs
    checker.check data

    expect(pIs).toHaveBeenCalled()
    expect(successCallback).toHaveBeenCalled()

  it 'should throw exception if predicate fails 1', ->
    checker.addPredicate 'len', 99
    checker.check data

    expect(failCallback).toHaveBeenCalled()

  it 'should throw exception if predicate fails 2', ->
    checker.addPredicate 'len', 99, pIs
    checker.check data

    expect(pIs).toHaveBeenCalled()
    expect(failCallback).toHaveBeenCalled()
