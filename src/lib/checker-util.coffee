_ = require 'underscore'
predicate = require './predicate'
DataChecker = require './checker'

exports.makeDataCheckerFromObj = (obj) ->
  checker = new DataChecker()

  _.forEach obj, (predicates, selector) =>
    if _.isObject predicates
      _.forEach predicates, (expectedValue, pname) =>
        if predicate.get(pname)?
          checker.addPredicate(selector, expectedValue, predicate.get(pname))
        else
          console.warn "predicate does not exists: #{pname}"
    else
      expectedValue = predicates
      checker.addPredicate(selector, expectedValue, predicate.get('is'))

  checker
