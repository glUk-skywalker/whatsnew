require "#{Rails.root}/app/helpers/builds_helper"
include BuildsHelper

namespace :check do
	task :main => :environment do
	  puts DateTime.now.to_s + ' checking main started...'
	  check_build('main')
	  puts DateTime.now.to_s + ' checking main finished'
	end

	task :beta => :environment do
	  puts DateTime.now.to_s + ' checking beta started...'
	  check_build('beta')
	  puts DateTime.now.to_s + ' checking beta finished'
	end

  task :populate => :environment do
    require 'open-uri'

    build_bugs = open("#{ Settings.updates_url }/main/whatsnew.txt").read.split('Date:   ')[1..-1].each do |build_info|
      number = build_info.scan(/Build:  6\.\d\.\d+/)[0].split('.').last
      whatsnew_time = DateTime.strptime(build_info.scan(/\d{1,2}\/\d{1,2}\/\d{1,2}/)[0].insert(-3, '20'), '%m/%d/%Y')
      build_bugs = build_info.scan(/#\d+/).map{ |e| e[1..-1] }.join(",")
      tag = "main"

      Build.create(number: number, tag: tag, bug_list: build_bugs, whatsnew_time: whatsnew_time)
    end
  end
end