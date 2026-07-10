source "https://rubygems.org"

def next?
  File.basename(__FILE__) == "Gemfile.next"
end

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby file: ".ruby-version"

# rubocop:disable Style/IdenticalConditionalBranches
# Rails 8.1 is now the production version, so both boots target it. The dual-boot
# scaffold is kept intact so the next hop only needs to bump the `next?` branch.
if next?
  gem "rails", ">= 8.1.0", "< 8.2.0"
else
  gem "rails", ">= 8.1.0", "< 8.2.0"
end
# rubocop:enable Style/IdenticalConditionalBranches

gem "bundler-audit"
gem "next_rails"
gem "ostruct"
# `< 1.3.5` was a Rails 6.1-era compatibility guard (concurrent-ruby 1.3.5
# dropped its `logger` dependency, breaking Rails < 7.1); obsolete on Rails
# 8.1. Now a security floor instead: 1.3.4 carries CVE-2026-54904/5/6, fixed
# in 1.3.7.
gem "concurrent-ruby", ">= 1.3.7"
gem "puma", "~> 8.0"
# minitest 6.0 moved minitest/mock into a separate minitest-mock gem. The test
# suite uses it (`require "minitest/mock"` + `.stub`), so it's declared
# explicitly now that we're on minitest 6.
gem "minitest"
gem "minitest-mock"
gem "nokogiri", ">= 1.13.0"
gem "sass-rails", "~> 6.0"
gem "terser"

gem "redcarpet"
gem "wicked_pdf", "~> 2.8"
# wkhtmltopdf-binary is held at 0.12.3.1: the 0.12.6.x Linux binary segfaults
# (SIGSEGV) in CI/Heroku, and 0.12.6 also blocks local file access by default,
# which breaks the PDF's logo/stylesheet. wkhtmltopdf is EOL, so 0.12.3.1 stays.
gem "wkhtmltopdf-binary", "0.12.3.1"

gem "fastruby-styleguide", git: "https://github.com/fastruby/styleguide.git", branch: "gh-pages"

# paperclip is unmaintained since 2018 and calls URI.escape (removed in Ruby
# 3.0); kt-paperclip is a maintained, actively-released fork that fixes this
# and stays drop-in compatible (same Paperclip:: module/require path).
gem "kt-paperclip", "~> 8.0.0", require: "paperclip"
# aws-sdk v2's aws-sdk-core relies on implicit block capture via
# `Proc.new` with no block, removed in Ruby 3.0. kt-paperclip's S3
# storage adapter already targets aws-sdk-s3 (the modern per-service
# SDK, same Aws::S3:: namespace) directly -- no application code
# changes needed, just the gem swap.
gem "aws-sdk-s3"

gem "pg", "~> 1.1"

group :development, :test do
  gem "capybara", "~> 3.40"
  gem "rubocop-rails-omakase", require: false
  gem "selenium-webdriver"
  gem "dotenv-rails"
end

group :development do
  gem "web-console", ">= 3.3.0"
  gem "listen", ">= 3.5"
  gem "reek"
end

# Exception tracking. Reports unhandled exceptions to Sentry in production;
# the DSN is supplied via the SENTRY_DSN env var (see .env.sample). sentry-rails
# auto-installs the Rack/Rails middleware, so no controller changes are needed.
group :production do
  gem "sentry-ruby"
  gem "sentry-rails"
end

gem "tzinfo-data", platforms: [:windows, :jruby]
