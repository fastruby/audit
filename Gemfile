def next?
  File.basename(__FILE__) == "Gemfile.next"
end
source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby "2.7.2"

if next?
  gem "rails", github: "rails/rails", branch: "main"
else
  gem "rails", "~> 6.1.0"
end

gem "bundler-audit"
# Use sqlite3 as the database for Active Record
# gem 'sqlite3'
# Use Puma as the app server
gem "puma", "~> 3.7"
gem "nokogiri", "~> 1.8.2"
# Use SCSS for stylesheets
gem "sass-rails", "~> 5.0"
# Font awesome
gem "font-awesome-rails"
# Use Uglifier as compressor for JavaScript assets
gem "uglifier", ">= 1.3.0"
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem "coffee-rails", "~> 5.0"
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem "turbolinks", "~> 5"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.5"
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'
gem "redcarpet"
# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem "wicked_pdf", "1.4.0"
gem "wkhtmltopdf-binary", "0.12.3.1"

# FastRuby Styleguide
gem "fastruby-styleguide", git: "https://github.com/fastruby/styleguide.git", branch: "gh-pages"

gem "paperclip", "~> 5.2.1"
gem "aws-sdk", "~> 2.3.0"

gem "pg", "~> 1.1"

gem "clipboard-rails"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13'
  gem 'rspec-rails'
  gem "rubocop-rails", require: false # rails rules for standard
  gem "rubocop-rspec", require: false # rspec rules for standard
  gem 'selenium-webdriver'
  gem "standard"
  gem 'dotenv-rails'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem "web-console", ">= 3.3.0"
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "reek" # code smells linter
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
