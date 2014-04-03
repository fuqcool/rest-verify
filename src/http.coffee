http = require 'http'

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
        host: @host
        port: @port
        path: @path
        method: @method
        headers: @headers

      req = http.request options, (res) =>
        res.setEncoding 'utf8'
        data = ''

        res.on 'data', (chunk) ->
          data += chunk

        res.on 'end', =>
          cb?(@_parse data)

      req.on 'end', ->
        console.log 'request end'

      req.on 'error', (e) ->
        console.log 'request failed' + e.message

      req.end()

    _parse: (data) ->
      if @type is 'json'
        @_parseJson data

    _parseJson: (data) ->
      JSON.parse data

    setHeader: (obj) ->
      @headers[k] = v for k, v in obj
