fs = require 'fs'

readline = require 'readline'
read = readline.createInterface process.stdin, process.stdout

REDIRECT_URI = 'urn:ietf:wg:oauth:2.0:oob'
TOKEN_FILE = '_oauth2_token'

firstTime = true

authenticate = (config, request, callback) ->
  handleToken = (obj) ->
    token = oauth2.AccessToken.create obj

    helper = ->
      request.headers['Authorization'] = "Bearer #{token.token.access_token}"
      callback?()

    # it's safe to assume that the test will end in an hour
    if firstTime
      firstTime = false

      token.refresh (error, result)->
        console.log "Refresh token error #{error.message}" if error
        token = result
        helper()
    else
      helper()


  fetchNewToken = (callback) ->
    authUri = oauth2.AuthCode.authorizeURL({
      redirect_uri: REDIRECT_URI
      scope: config.scope
    })

    console.log "Please visit #{authUri}"

    read.question "Enter authorization code:", (code) ->
      console.log code
      oauth2.AuthCode.getToken({
        code: code
        redirect_uri: REDIRECT_URI
      }, (error, token) ->
        console.log "Access token error #{error.message}" if error

        saveToken token
        callback? token
      )

  oauth2 = require('simple-oauth2')({
    clientID: config.clientId
    clientSecret: config.clientSecret
    site: config.site
    authorizationPath: config.authPath ? '/auth'
    tokenPath: config.tokenPath ? '/token'
  })

  if fs.existsSync TOKEN_FILE
    token = createTokenFromFile TOKEN_FILE
    if token?
      handleToken token
    else
      fetchNewToken handleToken
  else
    fetchNewToken handleToken


createTokenFromFile = (file) ->
  try
    content = fs.readFileSync(file).toString()
    token = JSON.parse content
  catch
    token = null
  finally
    token


saveToken = (token) ->
  fs.writeFileSync TOKEN_FILE, JSON.stringify(token)

module.exports = authenticate
