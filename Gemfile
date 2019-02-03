source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '~> 2.4.3'

gem 'rails', '~> 5.2.2'
gem 'sqlite3'
gem 'unicorn'
gem 'puma', '~> 3.11'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'bundler', '>= 2.0.1'

gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'

# model
gem 'auto_strip_attributes', '~> 2.5'

# auth
gem 'devise', '~> 4.5'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2', '~> 0.6.0'
gem 'omniauth-kakao', :git => 'git://github.com/johnnyshields/omniauth-kakao'
gem 'omniauth-naver'
gem 'omniauth-twitter'

# file
gem 'carrierwave'
gem 'mini_magick'
gem 'file_validators'

# view
gem 'jquery-rails', '~> 4.3', '>= 4.3.3'
gem 'haml-rails', '~> 1.0'
gem 'unobtrusive_flash'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  gem 'chromedriver-helper'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
