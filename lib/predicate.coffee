fs = require 'fs'
path = require 'path'

predicates = {}

getPredicate = (name) ->
  if predicates[name]? then predicates[name]? else null

collectPredicates = (dir) ->
  collection = {}
  files = fs.readdirSync(dir)
  files = (f for f in files when path.extname(f) is '.coffee')
  for f in files
    name = path.basename f, '.coffee'
    try
      collection[name] = require path.join(dir, f)
    catch
      console.warn "failed to load predicat: #{name}"

  collection

collectPredicates path.resolve(__dirname, '../predicate')


module.exports =
  get: getPredicate
