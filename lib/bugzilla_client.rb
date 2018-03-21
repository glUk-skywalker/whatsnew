class BugzillaClient

  BASE_URL = Settings.bugzilla_url
  CREDENTIALS =  {
    login: Settings.bugzilla.login,
    password:  Settings.bugzilla.password
  }

  def self.get_bugs(bugs_list)
    get('/bug', { id: bugs_list })['bugs'].each{ |b|
      b.slice! *%w(id summary status creator cc qa_contact product)
    }
  end

  def self.get_bugs_history(bugs_list)
    get_bugs_history_xmlrpc(bugs_list).map{ |b| b.slice("id", "history") }
  end

  private

  def self.get_bugs_history_restapi(bugs_list)
    bugs_history = []
    bugs_list.split(',').each{ |b|
      bugs_history << get("/bug/#{ b }/history")
    }
    bugs_history
  end

  def self.get_bugs_history_xmlrpc(bugs_list)
    require 'xmlrpc/client'
    require 'openssl'

    server = XMLRPC::Client.new2("#{ Settings.bugzilla_url }/xmlrpc.cgi")
    server.instance_variable_get(:@http).instance_variable_set(:@verify_mode, OpenSSL::SSL::VERIFY_NONE)

    bug = server.proxy 'Bug'

    params = {
      ids: bugs_list.split(','),
      Bugzilla_login: CREDENTIALS[:login],
      Bugzilla_password: CREDENTIALS[:password]
    }

    bug.history(params)['bugs']
  end

  def self.get(url, params = {})
    params.merge! CREDENTIALS
    resp = RestClient.get BASE_URL + '/rest.cgi' + url, { params: params }
    JSON.parse resp.body
  end

end
