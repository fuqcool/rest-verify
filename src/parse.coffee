yaml = require 'js-yaml'
TestCase = require './testcase'

module.exports =
  parse: (text) ->
    try
      obj = yaml.safeLoad text
      obj
    catch (e)
      throw 'Error parsing test case: #{e.message}'

