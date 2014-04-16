_ = require 'underscore'
predicateManager = require './predicate'
EventEmitter = require('events').EventEmitter

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
            result = result(expectedValue)
            expectedValue = true

          if result isnt expectedValue
            @emit('fail',
                  selector: selector
                  predicate: pname
                  expectedValue: expectedValue
                  actualValue: result)
          else
            @emit('success')

    _selectObj: (data, selector) ->
      try
        eval('with (data) { eval(selector) }')
      catch e
        console.log "unable to parse selector: #{selector}, #{e.message}"
