source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.0.0"

# Core gems
gem 'rails', '7.0.6'
gem "sprockets-rails"
gem "puma", "~> 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
gem "bootsnap", require: false
gem 'devise'
gem 'httparty'
gem 'youtube_embed'
gem 'google-apis-youtube_v3'
gem 'kaminari'
# gem 'will_paginate', '~> 4.0.0' 
gem 'webpacker', '~> 6.0.0.rc.6'
gem 'social-share-button'
gem 'redis'

group :development, :test do
  # Debugging
  gem "debug", platforms: %i[ mri mingw x64_mingw ]

  # Database
  gem 'pg'

  # Environment variables
  gem 'dotenv-rails'

  # Testing
  gem 'rspec-rails'
  gem 'factory_bot_rails'

  # Spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.1.0'
end

group :development do
  gem "web-console"
  gem 'letter_opener'
  gem 'letter_opener_web'
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
  gem 'shoulda-matchers', '~> 4.0' 
  gem 'database_cleaner'
  gem 'rails-controller-testing'
end

gem "cssbundling-rails", "~> 1.3"
