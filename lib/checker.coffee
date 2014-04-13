_ = require 'underscore'

module.exports =
  class DataChecker
    constructor: () ->
      @predicates = []

    check: (data) ->
      p(data) for p in @predicates

    addPredicate: (selector, expectValue, predicate) ->
      @predicates.push do =>
        (data) =>
          actualValue = @_selectObj data, selector
          result = if predicate then predicate(actualValue) else actualValue

          if result isnt expectValue
            throw new Error(
              "failed: expect #{selector} to be #{expectValue}, actual: #{result}")
          else
            console.log 'succeed'

    _selectObj: (data, selector) ->
      try
        eval('with (data) { eval(selector) }')
      catch e
        console.log "unable to parse selector: #{selector}, #{e.message}"
