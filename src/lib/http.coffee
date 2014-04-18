lingo = require 'lingo'
_ = require 'underscore'

DEFAULT_PORT =
  http: 80
  https: 443

module.exports =
  class HttpRequest
    constructor: ->
      @headers = {}
      @path = '/'
      @method = 'get'
      @hostname = null
      @host = '127.0.0.1'
      @type = 'json'
      @protocol = 'http'
      @params = {}
      @body = null

    execute: (cb) ->
      if @body?
        @headers['Content-Length'] = @body.length

      port = @port ? @_getDefaultPort()
      path = @path + @_encodeParams(@params)
      startTime = null

      options =
        hostname: @hostname
        port: port
        path: path
        method: @method
        headers: @headers

      client = @_getClient()

      req = client.request options, (res) =>
        console.log "#{@method.toUpperCase()} #{@protocol}://#{@hostname + path}:#{port} ..."
        res.setEncoding 'utf8'
        body = ''

        res.on 'data', (chunk) ->
          body += chunk

        res.on 'end', =>
          stopTime = new Date

          console.log "timecost: #{stopTime.getTime() - startTime.getTime()}ms"

          if res.statusCode is 200
            cb?(
              statusCode: res.statusCode
              headers: @_normalizeObject res.headers
              data: @_parse body
              timeCost: stopTime.getTime() - startTime.getTime()
            )
          else
            cb?(statusCode: res.statusCode)

      req.on 'end', ->
        console.log 'request end'

      req.on 'error', (e) ->
        console.log 'request failed' + e.message

      if @body?
        req.write @body

      req.end()
      startTime = new Date

    _parse: (data) ->
      if @type is 'json'
        try
          @_parseJson data
        catch
          data
      else if @type is 'text'
        data
      else
        @_parseJson data

    _parseJson: (data) ->
      JSON.parse data

    _normalizeObject: (obj) ->
      result = {}

      _.map obj, (value, key) ->
        key = key.replace '-', ' '
        result[lingo.camelcase key] = value

      result

    _getDefaultPort: ->
      DEFAULT_PORT[@protocol]

    _getClient: ->
      if @protocol is 'https'
        require 'https'
      else
        require 'http'

    setHeader: (obj) ->
      @headers[k] = v for k, v in obj

    _encodeParams: (obj) ->
      return '' if not _.isObject(obj)

      parts = _.map obj, (value, key) ->
        encodedValue = encodeURIComponent value
        "#{key}=#{encodedValue}"

      if parts.length is 0 then '' else '?' + parts.join '&'
