module BuildsHelper

  def check_build(tag)
    last_build = WhatsnewDownloader.get_for('beta').parsed.first
    Build.create(last_build) unless Build.find_by_number(last_build[:number])

    config = Rails.configuration.database_configuration
    db = config[Rails.env]["database"]
    usr = config[Rails.env]["username"]
    pwd = config[Rails.env]["password"]
    system "mysqldump -u#{ usr } -p#{ pwd } #{ db } > ./db/db_dump.sql"
  end

end
