class PhabricatorClient
  BASE_URL = Settings.phabricator.url
  TOKEN = Settings.phabricator.token

  def self.get_tasks(task_list)
    return [] if task_list.empty?
    hash_content = []

    c_path = "#{Rails.root}/bin/phab_client"
    token_prm = "--token=\"#{TOKEN}\""
    url_prm = "--url=\"#{BASE_URL}\""
    ids_prm = "--ids=#{task_list.join(',')}"
    json_string = `#{c_path} #{token_prm} #{url_prm} #{ids_prm}`

    JSON.parse(json_string).each do |t_i|
      hash_content << make_task(t_i)
    end
    hash_content
  end

  def self.make_task(data)
    task = {}
    task[:id] = data['id']
    task[:summary] = data['fields']['name']
    task[:status] = data['fields']['status']['value'].upcase
    task[:creator] = Tester.find_by_phab_id(data['fields']['authorPHID'])&.email
    task[:cc] = relations(data)
    task[:qa_contact] = 'TODO'
    task[:product] = data['projects'].join("\n")
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
    hash_response['result']['data'].map{ |_, v| v['name'] }
  end

  def self.projects_url(params)
    "#{BASE_URL}/api/project.query?api.token=#{TOKEN}&#{params.to_query}"
  end
end
