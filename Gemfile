def next?
  File.basename(__FILE__) == "Gemfile.next"
end
source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby "2.7.2"

# activerecord 7.1.4+ uses `def method_missing(name, ...)` (leading arg +
# `...` forwarding), which is Ruby 3.0+ only syntax and fails to parse on
# our Ruby 2.7.2, despite the rails gemspec still advertising `>= 2.7.0`.
# Cap below that until Ruby is separately upgraded past 3.0.
# Both branches target the same range for now; bump the `if next?` branch
# to start the next dual-boot hop (7.2).
# rubocop:disable Style/IdenticalConditionalBranches
if next?
  gem "rails", ">= 7.1.0", "< 7.1.4"
else
  gem "rails", ">= 7.1.0", "< 7.1.4"
end
# rubocop:enable Style/IdenticalConditionalBranches

gem "bundler-audit"
gem "next_rails"
# concurrent-ruby >= 1.3.5 breaks Rails' logger require order on Ruby 2.7
gem "concurrent-ruby", "< 1.3.5"
# Use sqlite3 as the database for Active Record
# gem 'sqlite3'
# Use Puma as the app server
gem "puma", "~> 3.7"
gem "nokogiri", ">= 1.13.0"
# Use SCSS for stylesheets
gem "sass-rails", "~> 5.0"
# Font awesome
gem "font-awesome-rails", ">= 4.7.0.9"
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

# paperclip is unmaintained since 2018 and calls URI.escape (removed in Ruby
# 3.0); kt-paperclip is a maintained, actively-released fork that fixes this
# and stays drop-in compatible (same Paperclip:: module/require path).
gem "kt-paperclip", "~> 8.0.0", require: "paperclip"
gem "aws-sdk", "~> 2.3.0"

gem "pg", "~> 1.1"

gem "clipboard-rails"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13'
  gem "rubocop-rails", require: false # rails rules for standard
  gem 'selenium-webdriver'
  gem "standard"
  gem 'dotenv-rails'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem "web-console", ">= 3.3.0"
  gem "listen", ">= 3.5"
  gem "reek" # code smells linter
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  # spring >= 4 (needed for Rails 7 support) requires Ruby >= 3.1; re-add once Ruby is upgraded.
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
