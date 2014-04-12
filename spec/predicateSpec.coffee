predicate = require '../lib/predicate'
path = require 'path'

describe 'predicate', ->
  beforeEach ->
    predicate.collect path.resolve(__dirname, '../predicate')

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


    expect(-> len '123').toThrow()
    expect(len [1, 2, 3]).toBe(3)
