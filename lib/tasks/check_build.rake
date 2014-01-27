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
end