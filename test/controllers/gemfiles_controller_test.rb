require "test_helper"

class GemfilesControllerTest < ActionDispatch::IntegrationTest
  test "create with an empty file sets an error message in flash" do
    post gemfiles_path

    assert_equal "File can't be blank", flash[:error]
  end

  test "create with an invalid Gemfile.lock redirects to the homepage with an error message" do
    file = File.new(Rails.root.join("test/fixtures/files/corrupt.lock"))
    file_upload = fixture_file_upload(file)

    post gemfiles_path, params: {gemfile: {file: file_upload}}

    assert_redirected_to root_path
    assert_includes flash[:error], "File has contents that are not what they are reported to be"
    assert_includes flash[:error], "File is invalid"
    assert_includes flash[:error], "File content type is invalid"
  end

  test "show with a numeric id raises RecordNotFound since lookup is by alpha_id" do
    gemfile = Gemfile.create(file: File.new(Rails.root.join("test/fixtures/files/Gemfile.lock")))

    assert_raises(ActiveRecord::RecordNotFound) do
      get gemfile_path(id: gemfile.id)
    end
  end

  test "show with the alpha_id renders successfully" do
    gemfile = Gemfile.create(file: File.new(Rails.root.join("test/fixtures/files/Gemfile.lock")))

    get gemfile_path(id: gemfile.alpha_id)

    assert_response :success
  end

  test "show with the PDF format renders a PDF successfully" do
    gemfile = Gemfile.create(file: File.new(Rails.root.join("test/fixtures/files/Gemfile.lock")))

    get gemfile_path(id: gemfile.alpha_id, format: :pdf)

    assert_response :success
    assert_equal "application/pdf", response.content_type
    assert response.body.start_with?("%PDF")
  end
end
