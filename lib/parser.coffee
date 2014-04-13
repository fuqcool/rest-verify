yaml = require 'js-yaml'
Testcase = require './testcase'
_ = require 'underscore'
predicate = require './predicate'

module.exports =
  parse: (text) ->
    try
      obj = yaml.safeLoad text
      @_makeTestcase(obj, null)
    catch e
      throw "Error parsing test case: #{e.message}"

  _makeTestcase: (obj, parent) ->
    testcase = new Testcase
    if obj.request?
      _.extend(testcase.request,
              if parent? then parent.request,
              if obj? then obj.request)

    if obj.response?.expect?
      _.forEach obj.response.expect, (predicates, selector) =>
        if _.isObject predicates
          _.forEach predicates, (value, pname) =>
            if predicate.get(pname)?
              testcase.checker.addPredicate(selector, value, predicate.get(pname))
            else
              console.warn "predicate does not exists: #{pname}"
        else
          #console.log 'hello'
          value = predicates
          testcase.checker.addPredicate(selector, value, predicate.get('is'))

    if obj.then?
      testcase.then = @_makeTestcase(obj.then, obj)

    testcase
