class PhabricatorClient
  BASE_URL = Settings.phabricator.url
  TOKEN = Settings.phabricator.token
  CREDENTIALS = {
    login: Settings.bugzilla.login,
    password:  Settings.bugzilla.password
  }.freeze

  def self.get_tasks(task_list)
    return [] if task_list.empty?
    next_page = true
    hash_content = []

    params = { constraints: { ids: task_list } }
    loop do
      uri = URI(query_url(params))
      response = Net::HTTP.get(uri)
      hash_response = JSON.parse(response)

      hash_response['result']['data'].each do |t|
        hash_content << make_task(t)
      end

      next_page = hash_response['result']['cursor']['after']
      break unless next_page
      params[:after] = next_page
    end

    hash_content
  end

  def self.make_task(data)
    task = {}
    task[:id] = data['id']
    task[:summary] = data['fields']['name']
    task[:status] = data['fields']['status']['value'].upcase
    task[:creator] = Tester.find_by_phab_id(data['fields']['authorPHID'])&.email
    task[:cc] = ['TODO']
    task[:qa_contact] = 'TODO'
    task[:product] = 'TODO'
    task[:relations] = task[:creator] ? task[:relations] = [{ tester: task[:creator], relation: 'creator' }] : []
    task
  end

  def self.query_url(params)
    "#{BASE_URL}/api/maniphest.search?api.token=#{TOKEN}&#{params.to_query}"
  end
end
