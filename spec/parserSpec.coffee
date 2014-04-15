parser = require '../lib/parser'
fs = require 'fs'
_ = require 'underscore'
path = require 'path'

describe 'parser', ->
  testcase = null

  parseFromFile = (f) ->
    parser.parse f

  describe 'parse config', ->
    beforeEach ->
      testcase = parseFromFile(path.join(__dirname, 'fixture/config.yml'))

    it 'should parse request', ->
      expect(testcase.request.hostname).toBe 'net4.ccs.neu.edu'
      expect(testcase.request.path).toBe '/home/fuqcool/blueos/rest/file'
      expect(testcase.request.method).toBe 'get'

    it 'should parse checker', ->
      expect(->
        testcase.checker.check(
          data: new Array(10)
          statusCode: 200
          headers:
            contentType: 'text/json'
        )
      ).not.toThrow()

    it 'should parse nested request', ->
      testcase = testcase.then

      # use parent options by default
      expect(testcase.request.hostname).toBe 'net4.ccs.neu.edu'
      expect(testcase.request.path).toBe '/home/fuqcool/blueos/rest/app'
      expect(testcase.request.method).toBe 'get'

  describe 'parse use', ->
    beforeEach ->
      testcase = parseFromFile(path.join(__dirname, 'fixture/use.yml'))

    it 'should use config of another file', ->
      expect(testcase.auth.config.type).toBe 'oauth2'
      expect(testcase.request.hostname).toBe 'example.com'
      expect(testcase.request.path).toBe '/api'
