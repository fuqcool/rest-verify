_ = require 'underscore'

module.exports = (obj) -> not _.isArray(obj) and _.isObject(obj)
