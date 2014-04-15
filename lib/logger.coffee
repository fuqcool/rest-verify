clc = require 'cli-color'

makeLogger = (color) ->
  (msg) ->
    console.log clc[color](msg)

module.exports =
  red: makeLogger 'red'
  green: makeLogger 'green'
