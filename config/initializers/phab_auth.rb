PhabAuth.setup do |conf|
  conf.client_id = Settings.phabricator.login.client_id
  conf.client_secret = Settings.phabricator.login.client_secret
  conf.oauthserver_url = Settings.phabricator.login.oauthserver_url
  conf.create_session_path = :create_session_path
  conf.scheme = 'http'
end
