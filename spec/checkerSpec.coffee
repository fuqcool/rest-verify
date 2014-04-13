DataChecker = require '../lib/checker'

describe 'Data checker', ->
  checker = null
  data = null
  pIs = jasmine.createSpy('is').andCallFake (v) -> v

  beforeEach ->
    checker = new DataChecker
    data =
      'foo': 'bar'
      'len': 100

  describe 'check', ->
    it 'should use equal as predicate when predicate is not specified', ->
      checker.addPredicate 'foo', 'bar'

      expect(->
        checker.check(data)
      ).not.toThrow()

    it 'should take predicate', ->
      checker.addPredicate 'foo', 'bar', pIs

      expect(->
        checker.check(data)
      ).not.toThrow()

      expect(pIs).toHaveBeenCalled()

    it 'should throw exception if predicate fails 1', ->
      checker.addPredicate 'len', 99

      expect(->
        checker.check(data)
      ).toThrow()

    it 'should throw exception if predicate fails 2', ->
      checker.addPredicate 'len', 99, pIs

      expect(->
        checker.check(data)
      ).toThrow()

      expect(pIs).toHaveBeenCalled()
