source 'https://rubygems.org'
ruby '2.2.0'

gem 'rails', '4.2.1'
gem 'pg'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'haml-rails'
gem 'bootstrap-sass', '~> 3.3.4'
gem 'newrelic_rpm'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development do
  gem 'guard'
  gem 'guard-rspec'
  gem 'rspec-rails'
  gem 'guard-livereload', '~> 2.4', require: false
  gem 'rack-livereload'
  gem 'web-console', '~> 2.0'
  gem 'mailcatcher'
end

group :test do
  gem 'assert_difference'
  gem 'capybara'
end

group :test, :development do
  gem 'byebug'
end

group :production do
  gem 'rails_12factor'
end
