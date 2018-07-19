class PhabricatorClient
  BASE_URL = Settings.phabricator.url
  TOKEN = Settings.phabricator.token

  def self.get_tasks(task_list)
    return [] if task_list.empty?
    next_page = true
    hash_content = []

    params = { constraints: { ids: task_list }, attachments: { subscribers: true, projects: true } }
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
    task[:product] = get_project_names(data['attachments']['projects']['projectPHIDs']).join("\n")
    task[:relations] = relations(data)
    task
  end

  def self.relations(data)
    subs_phids = data['attachments']['subscribers']['subscriberPHIDs']
    subs_emails = Tester.where(phab_id: subs_phids).map(&:email)
    creator = Tester.find_by_phab_id(data['fields']['authorPHID'])&.email
    subs_emails -= [creator] if creator
    ret = []
    ret << { tester: creator, relation: 'creator' } if creator
    ret += subs_emails.map{ |s| { tester: s, relation: 'subscriber' } }
    ret
  end

  def self.query_url(params)
    "#{BASE_URL}/api/maniphest.search?api.token=#{TOKEN}&#{params.to_query}"
  end

  def self.get_project_names(phids)
    return [] if phids.empty?
    params = { phids: phids }
    uri = URI(projects_url(params))
    response = Net::HTTP.get(uri)
    hash_response = JSON.parse(response)
    hash_response['result']['data'].map{ |k, v| v['name'] }
  end

  def self.projects_url(params)
    "#{BASE_URL}/api/project.query?api.token=#{TOKEN}&#{params.to_query}"
  end
end
