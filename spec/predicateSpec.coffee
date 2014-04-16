predicate = require '../lib/predicate'
path = require 'path'

describe 'predicate', ->
  beforeEach ->
    predicate.collect path.resolve(__dirname, '../lib/predicate')

  it 'should get predicate name', ->
    isArray = predicate.get 'isArray'
    expect(predicate.getName isArray).toBe 'isArray'

  it 'should test isArray', ->
    isArray = predicate.get 'isArray'

    expect(isArray []).toBe true
    expect(isArray {}).toBe false

  it 'should test isNumber', ->
    isNumber = predicate.get 'isNumber'

    expect(isNumber 100).toBe true
    expect(isNumber '123').toBe false

  it 'should test isObject', ->
    isObject = predicate.get 'isObject'

    expect(isObject {a: 'b'}).toBe true
    expect(isObject []).toBe false

  it 'should test isString', ->
    isString = predicate.get 'isString'

    expect(isString '123').toBe true
    expect(isString 100).toBe false

  it 'should test array len', ->
    len = predicate.get 'len'

    # should work on string
    expect(len 'hello').toBe 5

    # should work on array
    expect(len [1, 2, 3]).toBe 3

    # should not work on other objects
    expect(-> len 123).toThrow()

  it 'should test match string', ->
    match = predicate.get 'match'
    result = match('hello')

    expect(result("^h.*")).toBe true
    expect(result("^ello")).toBe false

  it 'should check key exists in object', ->
    existsKey = predicate.get 'existsKey'
    result = existsKey(foo: 'bar')

    expect(result('foo')).toBe true
    expect(result('bar')).toBe false
