_ = require 'underscore'

module.exports = (obj) ->
  if _.isArray(obj) then obj.length else throw 'error: len'
