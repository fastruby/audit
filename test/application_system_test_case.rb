require "test_helper"
require "selenium/webdriver"

# Registered explicitly (instead of Rails' built-in :headless_chrome) so we
# can point at whichever Chromium/Chrome + driver pair is actually present --
# Debian's chromium/chromium-driver packages in Docker, Google Chrome +
# Selenium Manager on GitHub Actions' ubuntu-latest runners. Falls back to
# Selenium Manager (Selenium's own driver auto-resolver) when no known binary
# path is found, instead of hardcoding one environment's layout.
CHROME_BINARY_PATHS = %w[
  /usr/bin/chromium
  /usr/bin/chromium-browser
  /usr/bin/google-chrome
  /usr/bin/google-chrome-stable
].freeze

CHROMEDRIVER_PATHS = %w[
  /usr/bin/chromedriver
  /usr/lib/chromium/chromedriver
].freeze

Capybara.register_driver :headless_chromium do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  binary_path = CHROME_BINARY_PATHS.find { |path| File.exist?(path) }
  options.binary = binary_path if binary_path

  options.add_argument("--headless=new")
  options.add_argument("--no-sandbox")
  options.add_argument("--disable-dev-shm-usage")
  options.add_argument("--disable-gpu")
  options.add_argument("--window-size=1400,1400")

  driver_path = CHROMEDRIVER_PATHS.find { |path| File.exist?(path) }
  service = Selenium::WebDriver::Service.chrome(path: driver_path) if driver_path

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options, service: service)
end

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :headless_chromium
end
