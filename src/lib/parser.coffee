fs = require 'fs'
path = require 'path'
yaml = require 'js-yaml'
_ = require 'underscore'

Testcase = require './testcase'
predicate = require './predicate'
OAuth2 = require './auth/oauth2'
checkerUtil = require './checker-util'



module.exports =
  parse: (file) ->
    try
      config = @_parseConfig file

      @_makeTestcase(config, null)
    catch e
      throw "Error parsing test case: #{e.message}"

  _parseConfig: (file) ->
    content = fs.readFileSync(file).toString()
    config = yaml.safeLoad content
    config = {} if not config?

    if config.use?
      ancestor = @_parseConfig(path.join(path.dirname(file), config.use + '.yml'))

    config.request = _.extend({}, ancestor?.request, config?.request)
    config.auth = _.extend({}, ancestor?.auth, config?.auth)

    config

  _makeTestcase: (obj, parent) ->
    testcase = new Testcase

    if obj.request?
      _.extend(testcase.request,
              if parent? then parent.request,
              if obj? then obj.request)

    if obj.response?.type?
      testcase.request.type = obj.response.type

    if obj.auth?
      if obj.auth.type is 'oauth2'
        testcase.auth = new OAuth2 obj.auth

    if obj.response?.expect?
      testcase.checker = checkerUtil.makeDataCheckerFromObj(obj.response.expect)

    if obj.then?
      testcase.then = @_makeTestcase(obj.then, obj)

    testcase
