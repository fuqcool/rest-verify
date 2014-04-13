fs = require 'fs'
path = require 'path'
_ = require 'underscore'

predicatesCache = {}

getPredicate = (name) ->
  if predicatesCache[name]? then predicatesCache[name] else null

collectPredicates = (dir) ->
  predicates = {}
  files = fs.readdirSync(dir)
  files = (f for f in files when path.extname(f) is '.coffee')
  for f in files
    name = path.basename f, '.coffee'
    try
      predicates[name] = require path.join(dir, f)
    catch e
      console.warn "failed to load predicat: #{name}, #{e.message}"


  _.extend(predicatesCache, predicates)

module.exports =
  get: getPredicate
  collect: collectPredicates
