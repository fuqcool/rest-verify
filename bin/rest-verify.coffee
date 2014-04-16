#!/usr/bin/env node

fs = require 'fs'
path = require 'path'
argv = require('optimist').argv
parser = require '../lib/parser'
predicate = require '../lib/predicate'
run = require '../lib/run'

dirs = argv._

# load predicates
predicate.collect(path.resolve(__dirname, '../lib/predicate'))

# get config files
configFiles = []
for dir in dirs
  files = fs.readdirSync dir
  files = (path.normalize(path.join(dir, f)) for f in files)
  files = (f for f in files when path.extname(f) is '.yml' and path.basename(f)[0] isnt '_')
  configFiles = configFiles.concat files

# parse config files to test cases
testcases = []
for file in configFiles
  try
    testcases.push parser.parse(file)
  catch
    console.warn "failed to parse config file #{file}"

run testcases
