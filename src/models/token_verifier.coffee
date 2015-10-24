Octonode  = require "octonode"
###########################################################################

class TokenVerifier
  constructor: (token) ->
    @token = token.trim()
    api_uri = (process.env.HUBOT_GITHUB_API or 'https://api.github.com')
    @api   = Octonode.client(@token, { hostname: api_uri })
    @api.requestDefaults.headers['Accept'] = 'application/vnd.github.cannonball-preview+json'

  valid: (cb) ->
    @api.get "/user", (err, data, headers) ->
      scopes = headers? and headers['x-oauth-scopes']
      if scopes
        if scopes.indexOf('repo') >= 0
          cb(true)
        else if scopes.indexOf('repo_deployment') >= 0
          cb(true)
        else
          cb(false)
      else
        cb(false)

exports.TokenVerifier = TokenVerifier
