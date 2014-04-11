DataChecker = require '../lib/checker'

describe 'Data checker', ->
  checker = null
  data = null
  pIs = jasmine.createSpy('is').andCallFake (v) ->
    return v

  beforeEach ->
    checker = new DataChecker
    data = {
      'foo': 'bar',
      'len': 100
    }


  describe 'check', ->
    it 'should use equal as predicate when predicate is not specified', ->
      checker.addPredicate '$.foo', 'bar'

      expect(->
        checker.check(data)
      ).not.toThrow()

    it 'should take predicate', ->
      checker.addPredicate '$.foo', 'bar', pIs

      expect(->
        checker.check(data)
      ).not.toThrow()

      expect(pIs).toHaveBeenCalled()

    it 'should throw exception if predicate fails 1', ->
      checker.addPredicate '$.len', 99

      expect(->
        checker.check(data)
      ).toThrow()

    it 'should throw exception if predicate fails 2', ->
      checker.addPredicate '$.len', 99, pIs

      expect(->
        checker.check(data)
      ).toThrow()

      expect(pIs).toHaveBeenCalled()

  describe 'selector', ->
    it 'should select the object itself', ->
      obj = checker._selectObj {foo: 'bar'}, '$'

      expect(obj).toEqual {foo: 'bar'}

    it 'should select subobject', ->
      obj = checker._selectObj {foo: 'bar'}, '$.foo'
      expect(obj).toBe 'bar'

    it 'should select object by index', ->
      obj = checker._selectObj ['foo', 'bar'], '$[1]'
      expect(obj).toBe 'bar'
