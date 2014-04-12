parser = require '../lib/parser'
fs = require 'fs'
_ = require 'underscore'

describe 'parser', ->
  testcase = null

  describe 'parse config', ->
    beforeEach ->
      content = fs.readFileSync 'spec/fixture/config.yml'
      testcase = parser.parse content.toString()

    it 'should parse request', ->
      expect(testcase.request.hostname).toBe 'http://net4.ccs.neu.edu/'
      expect(testcase.request.path).toBe '/home/fuqcool/blueos/rest/config'
      expect(testcase.request.method).toBe 'get'

    it 'should parse checker', ->
      expect(->
        testcase.checker.check(data: [])
      ).not.toThrow()

    it 'should parse nested request', ->
      testcase = testcase.then

      # use parent options by default
      expect(testcase.request.hostname).toBe 'http://net4.ccs.neu.edu/'
      expect(testcase.request.path).toBe '/home/fuqcool/blueos/rest/file'
      expect(testcase.request.method).toBe 'get'
