module BuildsHelper
  def check_build(tag)
    last_build = WhatsnewDownloader.get_for(tag).parsed.first
    Build.create(last_build) unless Build.find_by_number(last_build[:number])

    config = Rails.configuration.database_configuration
    db = config[Rails.env]["database"]
    usr = config[Rails.env]["username"]
    pwd = config[Rails.env]["password"]
    system "mysqldump -u#{ usr } -p#{ pwd } #{ db } > ./db/db_dump.sql"
  end

  def check_alpha
    repo = Git.open Settings.pa6_repo_path
    last_tags = repo.tags[-2..-1]
    return if Build.find_by_number(last_tags.last.name[1..-1])
    all_messages = repo.log(1000).between(*last_tags.map(&:name)).map(&:message)
    messages = all_messages.map{ |msg| msg.match(/:R5:(T|\d)\d+/) }.compact
    issues = messages.map{ |msg| msg[0].gsub(':R5:', '') }
    build_params = {
      number: last_tags.last.name[1..-1],
      tag: 'alpha',
      bug_list: issues.reject{ |issue| issue[0] == 'T' }.uniq.join(','),
      task_list: issues.select{ |issue| issue[0] == 'T' }.uniq.join(','),
      whatsnew_time: repo.gcommit(last_tags.last.sha).date
    }
    Build.create(build_params)
  end
end
