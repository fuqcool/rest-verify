fs = require 'fs'
Auth = require './auth'

readline = require 'readline'

REDIRECT_URI = 'urn:ietf:wg:oauth:2.0:oob'
TOKEN_FILE = '_oauth2_token'

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

      @_fetchNewToken (token) =>
        @_handleToken token, -> callback?()

    beforeRequest: (request) ->
      request.headers['Authorization'] = "Bearer #{@token.token.access_token}"

    _handleToken: (obj, callback) ->
      @token = @oauth2.AccessToken.create obj

      @token.refresh (error, result) =>
        console.log "Refresh token error #{error.message}" if error
        @token = result
        callback?()

    _fetchNewToken: (callback) ->
      authUri = @oauth2.AuthCode.authorizeURL({
        redirect_uri: REDIRECT_URI
        scope: @config.scope
      })

      console.log "Please visit #{authUri}"

      read = readline.createInterface(
        input: process.stdin
        output: process.stdout
      )

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
