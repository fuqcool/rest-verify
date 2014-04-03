module.exports =
  class DataChecker
    constructor: () ->
      @predicates = []

    check: (data) ->
      p(data) for p in @predicates

    addPredicate: (predicate, selector) ->
      @predicates.push do =>
        (data) =>
          obj = if selector? then @selectObj data, selector else data
          result = predicate obj
          if not result
            throw 'failed'
          else
            console.log 'succeed'

    selectObj: (data, selector) ->
      if selector?
        data
      else
        data
