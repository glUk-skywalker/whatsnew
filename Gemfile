source 'https://rubygems.org'

ruby '2.5.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.2.10'

# Use mysql as the database for Active Record
gem "mysql2", "~> 0.3.14"
gem 'haml', '4.0.0'
gem 'bootstrap-sass', "~> 3.0.3.0"
gem "rails_config", "~> 0.3.3"
gem "whenever", "~> 0.9.0"
gem 'xmlrpc'
gem 'git', '~> 1.5'
gem 'phab_auth', git: 'https://github.com/glUk-skywalker/phab_auth.git'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

gem 'omniauth', '~> 1.3.2'
gem 'omniauth-ldap', git: "git://github.com/kolo/omniauth-ldap.git"

gem 'puma', '~> 3.4'
gem 'js_assets'

gem 'rest-client', '~> 2.0', '>= 2.0.2'

group :development do
  gem 'rails_layout'
  gem 'capistrano-rvm',     require: false
  gem 'capistrano',         require: false
  gem 'capistrano-rails',   require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano3-puma',   require: false

  gem 'highline', '~> 1.7', '>= 1.7.8'                                          # needed to suppress echoing symbols during input the password on deployment
end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
