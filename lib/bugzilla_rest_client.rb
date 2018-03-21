class BugzillaRestClient

  BASE_URL = Settings.bugzilla_url
  CREDENTIALS =  {
    login: Settings.bugzilla.login,
    password:  Settings.bugzilla.password
  }

  def initialize
    resp = RestClient.get BASE_URL + '/rest.cgi/login', { params: CREDENTIALS }
    resp_hash = JSON.parse resp.body
    @token = resp_hash['token']
  end

  def get_bugs(bugs_list)
    get('/bug', { id: bugs_list.join(",") })['bugs'].map{ |b|
      {
        id: b['id'],
        summary: b['summary'],
        status: b['status'],
        assignments: '',
        included: '',
        product: b['product']
      }
    }
  end

  private

  def get(url, params)
    params[:token] = @token
    puts params
    resp = RestClient.get BASE_URL + '/rest.cgi' + url, { params: params }
    JSON.parse resp.body
  end

end
