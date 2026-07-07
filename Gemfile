source "https://rubygems.org"

def next?
  File.basename(__FILE__) == "Gemfile.next"
end

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby "2.7.2"

# rubocop:disable Style/IdenticalConditionalBranches
if next?
  gem "rails", ">= 7.1.0", "< 7.1.4"
else
  gem "rails", ">= 7.1.0", "< 7.1.4"
end
# rubocop:enable Style/IdenticalConditionalBranches

gem "bundler-audit"
gem "next_rails"
gem "concurrent-ruby", "< 1.3.5"
gem "puma", "~> 3.7"
gem "nokogiri", ">= 1.13.0"
gem "sass-rails", "~> 5.0"
gem "font-awesome-rails", ">= 4.7.0.9"
gem "uglifier", ">= 1.3.0"

gem "coffee-rails", "~> 5.0"
gem "turbolinks", "~> 5"
gem "jbuilder", "~> 2.5"
gem "redcarpet"
gem "wicked_pdf", "1.4.0"
gem "wkhtmltopdf-binary", "0.12.3.1"

gem "fastruby-styleguide", git: "https://github.com/fastruby/styleguide.git", branch: "gh-pages"

# paperclip is unmaintained since 2018 and calls URI.escape (removed in Ruby
# 3.0); kt-paperclip is a maintained, actively-released fork that fixes this
# and stays drop-in compatible (same Paperclip:: module/require path).
gem "kt-paperclip", "~> 8.0.0", require: "paperclip"
gem "aws-sdk", "~> 2.3.0"

gem "pg", "~> 1.1"

gem "clipboard-rails"

group :development, :test do
  gem "capybara", "~> 2.13"
  gem "rubocop-rails-omakase", require: false
  gem "selenium-webdriver"
  gem "dotenv-rails"
end

group :development do
  gem "web-console", ">= 3.3.0"
  gem "listen", ">= 3.5"
  # reek >= 6.2.0 requires Ruby >= 3.0.0; 6.1.4 is the newest release still
  # compatible with our current Ruby 2.7.2, and its parser ~> 3.2.0 (vs the
  # old 6.0.4's parser ~> 3.0.0) is what actually unblocks rubocop's version.
  gem "reek", ">= 6.1.4", "< 6.2.0"
end

gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
