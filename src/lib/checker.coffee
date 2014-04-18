_ = require 'underscore'
predicateManager = require './predicate'
EventEmitter = require('events').EventEmitter
logger = require './logger'

module.exports =
  class DataChecker extends EventEmitter
    constructor: () ->
      @predicates = []

    check: (data) ->
      p(data) for p in @predicates

    addPredicate: (selector, expectedValue, predicate) ->
      @predicates.push do =>
        (data) =>
          pname = predicateManager.getName(predicate)
          actualValue = @_selectObj data, selector

          result = if predicate then predicate actualValue else actualValue

          if _.isFunction result
            _result = result(expectedValue)
            _expectedValue = true
          else
            _result = result
            _expectedValue = expectedValue

          if _result isnt _expectedValue
            @emit('fail',
                  selector: selector
                  predicate: pname
                  expectedValue: expectedValue
                  actualValue: JSON.stringify actualValue
                 )
          else
            @emit('success')

    _selectObj: (data, selector) ->
      try
        eval('with (data) { eval(selector) }')
      catch e
        logger.red "unable to parse selector: #{selector}, #{e.message}"
