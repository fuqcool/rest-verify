_ = require 'underscore'

module.exports = (obj) ->
  (regstr) ->
    pattern = new RegExp regstr
    _.isString(obj) and pattern.test(obj)
