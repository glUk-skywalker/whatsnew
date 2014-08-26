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
      build_bugs = open("#{ Settings.updates_url }/#{ tag }/whatsnew.txt").read.split("Bugs Resolved:")[1].scan(/\n#\d+/).map{ |e| e[2..-1] }.join(",")
      Build.create(number: new_build_number, tag: tag, bug_list: build_bugs, whatsnew_time: whatsnew_time)
    end

    config = Rails.configuration.database_configuration
    db = config[Rails.env]["database"]
    usr = config[Rails.env]["username"]
    pwd = config[Rails.env]["password"]
    system "mysqldump -u#{ usr } -p#{ pwd } #{ db } > ./db/db_dump.sql"
  end

end