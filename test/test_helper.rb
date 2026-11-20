require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "capybara"

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  Minitest.after_run do
    FileUtils.rm_rf(Rails.root.join("test/test_files"))
  end
end

# Remove this when a new Capybara version solvind this issue is released
# https://github.com/teamcapybara/capybara/pull/2868
# https://github.com/teamcapybara/capybara/pull/2867
Capybara::Selenium::Driver::ChromeDriver.class_eval do
  # Mirrors Capybara's upstream reset!, so keep its shape rather than splitting it up.
  # :reek:TooManyStatements
  def reset!
    # Use instance variable directly so we avoid starting the browser just to reset the session
    return unless @browser

    switch_to_window(window_handles.first)
    window_handles.slice(1..).each { |win| close_window(win) }
    return super if chromedriver_version < 73

    timer = Capybara::Helpers.timer(expire_in: 10)
    begin
      clear_storage unless uniform_storage_clear?
      @browser.navigate.to('about:blank')
      wait_for_empty_page(timer)
    rescue *unhandled_alert_errors
      accept_unhandled_reset_alert
      retry
    end

    execute_cdp('Storage.clearDataForOrigin', origin: "http://127.0.0.1", storageTypes: storage_types_to_clear)
  end
end
