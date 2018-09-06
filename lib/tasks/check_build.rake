require "#{Rails.root}/app/helpers/builds_helper"
include BuildsHelper

namespace :check do
  task main: :environment do
    puts DateTime.now.to_s + ' checking main started...'
    check_build('main')
    puts DateTime.now.to_s + ' checking main finished'
  end

  task beta: :environment do
    puts DateTime.now.to_s + ' checking beta started...'
    check_build('beta')
    puts DateTime.now.to_s + ' checking beta finished'
  end

  task alpha: :environment do
    puts DateTime.now.to_s + ' checking alpha started...'
    check_alpha
    puts DateTime.now.to_s + ' checking alpha finished'
  end

  task :populate => :environment do
    builds = WhatsnewDownloader.get_for('main').parsed
    # builds += WhatsnewDownloader.get_for('beta').parsed
    builds.each{ |build|
      Build.create(build) unless Build.find_by_number(build[:number])
    }
  end
end
