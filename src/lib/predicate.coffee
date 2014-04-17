fs = require 'fs'
path = require 'path'
_ = require 'underscore'
yaml = require 'js-yaml'

predicatesCache = {}

getPredicate = (name) ->
  if name is 'isApp'
    debugger

  if predicatesCache[name]? then predicatesCache[name] else null

getName = (target) ->
  result = null

  _.forEach predicatesCache, (predicate, name) ->
    result = name if predicate is target

  result

collectPredicates = (dir) ->
  checkerUtil = require './checker-util'

  predicates = {}
  files = fs.readdirSync(dir)
  files = (f for f in files when path.extname(f) in ['.coffee', '.js', '.yml'])
  for f in files
    ext = path.extname f
    name = path.basename(f, ext)

    try
      if ext in ['.coffee', '.js']
        predicates[name] = require path.join(dir, name)
      else if ext is '.yml'
        content = fs.readFileSync(path.join(dir, f)).toString()
        obj = yaml.safeLoad content

        predicates[name] = (actual) ->
          success = true

          checker = checkerUtil.makeDataCheckerFromObj(obj)
          checker.on 'fail', ->
            success = false

          checker.check(actual)
          success
    catch e
      console.warn "failed to load predicat: #{name}, #{e.message}"


  _.extend(predicatesCache, predicates)

module.exports =
  get: getPredicate
  getName: getName
  collect: collectPredicates
