_ = require 'underscore'

module.exports =
  class DataChecker
    constructor: () ->
      @predicates = []

    check: (data) ->
      p(data) for p in @predicates

    addPredicate: (predicate, selector) ->
      @predicates.push do =>
        (data) =>
          obj = @_selectObj data, selector
          result = predicate obj
          if not result
            throw 'failed'
          else
            console.log 'succeed'

    _selectObj: (data, selector) ->
      selector = selector ? '$'
      $ = data

      try
        eval(selector)
      catch
        data
