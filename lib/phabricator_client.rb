class PhabricatorClient
  BASE_URL = Settings.phabricator.url
  TOKEN = Settings.phabricator.token
  CREDENTIALS = {
    login: Settings.bugzilla.login,
    password:  Settings.bugzilla.password
  }.freeze

  def self.get_tasks(task_list)
    next_page = true
    hash_content = []

    params = { constraints: { ids: task_list } }
    loop do
      url = "#{BASE_URL}/api/maniphest.search?api.token=#{TOKEN}&#{params.to_query}"
      uri = URI(url)
      response = Net::HTTP.get(uri)
      hash_response = JSON.parse(response)

      hash_response['result']['data'].each do |t|
        task = {}
        task[:id] = t['id']
        task[:summary] = t['fields']['name']
        task[:status] = t['fields']['status']['value'].upcase
        task[:creator] = t['fields']['authorPHID']
        task[:cc] = ['TODO']
        task[:qa_contact] = 'TODO'
        task[:product] = 'TODO'
        hash_content << task
      end

      next_page = hash_response['result']['cursor']['after']
      break unless next_page
      params[:after] = next_page
    end

    hash_content
  end
end
