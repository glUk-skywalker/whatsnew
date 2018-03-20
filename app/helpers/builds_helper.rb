module BuildsHelper

  def check_build(tag)
    whatsnew_time = nil
    Net::HTTP.start(Settings.base_url) do |http|
      response = http.request_head("/paupdate/#{ tag }/whatsnew.txt")
      whatsnew_time = DateTime.parse(response['Last-Modified'])
    end

    require 'open-uri'

    new_build_number = open("#{ Settings.updates_url }/#{ tag }/buildno.txt").read

    if !Build.any? || Build.find_by(number: new_build_number).nil?
      content = open("#{ Settings.updates_url }/#{ tag }/whatsnew.txt").read
      build_info = content.split(/Build:  6.[0,5].\d+/)[1]
      bugs_n_tasks = build_info.scan(/\n[#,T]\d+/).map{ |b| b[1..-1] }
      bugs = bugs_n_tasks.select{ |b| b[0] == '#' }.map{ |b| b[1..-1] }.join(',')

      Build.create(number: new_build_number, tag: tag, bug_list: bugs, whatsnew_time: whatsnew_time)
    end

    config = Rails.configuration.database_configuration
    db = config[Rails.env]["database"]
    usr = config[Rails.env]["username"]
    pwd = config[Rails.env]["password"]
    system "mysqldump -u#{ usr } -p#{ pwd } #{ db } > ./db/db_dump.sql"
  end

end
