DataChecker = require '../lib/checker.coffee'

describe 'Data checker', ->
  checker = null
  pfail = null
  psuccess = null

  beforeEach ->
    checker = new DataChecker
    pfail = jasmine.createSpy('predicate').andReturn(false)
    psuccess = jasmine.createSpy('predicate').andReturn(true)

  it 'should add predicate', ->
    checker.addPredicate ->

    expect(checker.predicates.length).toBe 1

  it 'should not throw exception if predicate succeeds', ->
    checker.addPredicate psuccess

    expect(->
      checker.check({})
    ).not.toThrow()

  it 'should throw exception if predicate fails', ->
    checker.addPredicate pfail

    expect(->
      checker.check({})
    ).toThrow()
