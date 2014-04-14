fs = require 'fs'
path = require 'path'
argv = require('optimist').argv
parser = require '../lib/parser'
predicate = require '../lib/predicate'
_ = require 'underscore'

dirs = argv._

# load predicates
predicate.collect(path.resolve(__dirname, '../predicate'))

# get config files
configFiles = []
for dir in dirs
  files = fs.readdirSync dir
  files = (path.normalize(path.join(dir, f)) for f in files when path.extname(f) in ['.yml', '.yaml'])
  configFiles = configFiles.concat files

# parse config files to test cases
testcases = []
for config in configFiles
  try
    content = fs.readFileSync config
    testcases.push parser.parse(content.toString())
  catch
    console.warn "failed to parse config file #{config}"

# run test cases
_.forEach testcases, (test, i) ->
  test.on 'complete', ->
    if i isnt testcases.length - 1
      testcases[i+1].run()

if testcases.length isnt 0
  testcases[0].run()
