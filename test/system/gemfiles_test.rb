require "application_system_test_case"
require "net/http"

class GemfilesTest < ApplicationSystemTestCase
  test "uploading a Gemfile.lock renders the results page and a downloadable PDF" do
    visit root_path

    # The real file input is visually hidden by the custom upload widget's
    # CSS (a styled label/span sit in front of it); make_visible: false has
    # Capybara temporarily reveal it just for the attach, then hide it again.
    attach_file "gemfile_file", Rails.root.join("test/fixtures/files/Gemfile.lock"), make_visible: false
    click_button "Check file"

    assert_current_path %r{\A/gemfiles/\w+\z}
    assert_text "Vulnerabilities"
    assert_text "found on your file"

    pdf_response = Net::HTTP.get_response(URI("#{current_url}.pdf"))

    assert_equal "200", pdf_response.code
    assert_equal "application/pdf", pdf_response.content_type
    assert pdf_response.body.start_with?("%PDF")
  end
end
