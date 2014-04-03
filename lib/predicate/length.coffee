_ = require 'underscore'

module.exports = (obj, expectLen) -> _.isArray(obj) and obj.length is expectLen
