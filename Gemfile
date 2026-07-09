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
gem "concurrent-ruby", "< 1.3.5"
gem "puma", "~> 3.7"
# minitest 6.0 dropped minitest/mock.rb into a separate minitest-mock gem;
# pinned below 6 so a transitive bump (e.g. via `bundle update rails`)
# doesn't silently drag the test suite's own framework across a major
# version as collateral.
gem "minitest", "< 6"
gem "nokogiri", ">= 1.13.0"
gem "sass-rails", "~> 6.0"
gem "font-awesome-rails", ">= 4.7.0.9"
gem "terser"

gem "turbolinks", "~> 5"
gem "redcarpet"
gem "wicked_pdf", "1.4.0"
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
  # spring 4.x / spring-watcher-listen 2.1.x need Ruby >= 3.1, which we now
  # satisfy -- previously dropped during the Rails 6.1 -> 7.0 hop.
  gem "spring"
  gem "spring-watcher-listen", "~> 2.1.0"
end

gem "tzinfo-data", platforms: [:windows, :jruby]
