fs = require 'fs'
Auth = require './auth'

readline = require 'readline'
read = readline.createInterface process.stdin, process.stdout

REDIRECT_URI = 'urn:ietf:wg:oauth:2.0:oob'
TOKEN_FILE = '_oauth2_token'

firstTime = true

module.exports =
  class OAuth2 extends Auth
    authenticate: (callback) ->
      @oauth2 = require('simple-oauth2')({
        clientID: @config.clientId
        clientSecret: @config.clientSecret
        site: @config.site
        authorizationPath: @config.authPath ? '/auth'
        tokenPath: @config.tokenPath ? '/token'
      })

      if fs.existsSync TOKEN_FILE
        token = @_createTokenFromFile TOKEN_FILE
        if token?
          @_handleToken token, -> callback?()
          return

      @_fetchNewToken (token) ->
        @_handleToken token, -> callback?()

    beforeRequest: (request) ->
      request.headers['Authorization'] = "Bearer #{token.token.access_token}"

    _handleToken: (obj, callback) ->
      token = @oauth2.AccessToken.create obj

      # it's safe to assume that the test will end in an hour
      if firstTime
        firstTime = false

        token.refresh (error, result) ->
          consocle.log "Refresh token error #{error.message}" if error
          token = result
          callback?()
      else
        callback?()

    _fetchNewToken: (callback) ->
      authUri = @oauth2.AuthCode.authorizeURL({
        redirect_uri: REDIRECT_URI
        scope: config.scope
      })

      console.log "Please visit #{authUri}"

      read.question "Enter authorization code:", (code) =>
        @oauth2.AuthCode.getToken({
          code: code
          redirect_uri: REDIRECT_URI
        }, (error, token) =>
          console.log "Access token error #{error.message}" if error

          @_saveToken token
          callback? token
        )

    _createTokenFromFile: (file) ->
      try
        content = fs.readFileSync(file).toString()
        token = JSON.parse content
      catch
        token = null
      finally
        token

    _saveToken: (token) ->
      fs.writeFileSync TOKEN_FILE, JSON.stringify(token)
