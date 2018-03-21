class BugzillaRestClient

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

  private

  def self.get(url, params)
    params.merge! CREDENTIALS
    resp = RestClient.get BASE_URL + '/rest.cgi' + url, { params: params }
    JSON.parse resp.body
  end

end
