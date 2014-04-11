yaml = require 'js-yaml'
Testcase = require './testcase'
_ = require 'underscore'

module.exports =
  parse: (text) ->
    try
      obj = yaml.safeLoad text
      @_makeTestcase(obj)
    catch
      throw "Error parsing test case: #{e.message}"

  _makeTestcase: (obj) ->
    testcase = new Testcase
    if obj.request?
      testcase.request.path = obj.request.path
      testcase.request.hostname = obj.request.hostname
      testcase.request.method = obj.request.method

    if obj.response?.expect?
      _.forEach obj.response.expect, (predicates, selector) =>
        _.forEach predicates, (value, pname) =>
          testcase.checker.addPredicate(selector, value, @_getPredicate(pname))

    if obj.then?
      testcase.then = @_makeTestcase(obj.then)

    testcase

  _getPredicate: (pname) ->
    predicate = "./predicate/#{pname}"
    try
      require predicate
    catch
      throw "failed to load predicate: #{pname}"
