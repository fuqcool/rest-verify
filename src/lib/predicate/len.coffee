_ = require 'underscore'

module.exports = (obj) ->
  if _.isArray(obj) or _.isString(obj)
    obj.length
  else
    throw new Error('error: len')
