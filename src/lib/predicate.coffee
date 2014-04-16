fs = require 'fs'
path = require 'path'
_ = require 'underscore'

predicatesCache = {}

getPredicate = (name) ->
  if predicatesCache[name]? then predicatesCache[name] else null

getName = (target) ->
  result = null

  _.forEach predicatesCache, (predicate, name) ->
    result = name if predicate is target

  result

collectPredicates = (dir) ->
  predicates = {}
  files = fs.readdirSync(dir)
  files = (f for f in files when path.extname(f) in ['.coffee', '.js'])
  for f in files
    name = path.basename(f, path.extname(f))
    try
      predicates[name] = require path.join(dir, f)
    catch e
      console.warn "failed to load predicat: #{name}, #{e.message}"


  _.extend(predicatesCache, predicates)

module.exports =
  get: getPredicate
  getName: getName
  collect: collectPredicates
