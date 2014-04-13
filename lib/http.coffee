http = require 'http'
lingo = require 'lingo'
_ = require 'underscore'

module.exports =
  class HttpRequest
    constructor: ->
      @headers = {}
      @port = 80
      @path = '/'
      @method = 'get'
      @hostname = null
      @host = '127.0.0.1'
      @type = 'json'

    execute: (cb) ->
      options =
        hostname: @hostname
        # host: @host
        port: @port
        path: @path
        method: @method
        # headers: @headers

      req = http.request options, (res) =>
        debugger
        res.setEncoding 'utf8'
        body = ''

        res.on 'data', (chunk) ->
          body += chunk

        res.on 'end', =>
          cb?(
            statusCode: res.statusCode
            headers: @_normalizeObject res.headers
            data: @_parse body
          )

      req.on 'end', ->
        console.log 'request end'

      req.on 'error', (e) ->
        console.log 'request failed' + e.message

      req.end()

    _parse: (data) ->
      if @type is 'json'
        @_parseJson data
      else
        null

    _parseJson: (data) ->
      JSON.parse data

    _normalizeObject: (obj) ->
      result = {}

      _.map obj, (value, key) ->
        key = key.replace '-', ' '
        result[lingo.camelcase key] = value

      result

    setHeader: (obj) ->
      @headers[k] = v for k, v in obj
