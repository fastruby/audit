require "rails_helper"

RSpec.describe GemfilesController, type: :controller do
  render_views

  describe "#create" do
    context "when file is empty" do
      let(:msg) do
        "File can't be blank"
      end

      it "returns an error message" do
        post :create

        expect(flash[:error]).to eq(msg)
      end
    end

    context "when Gemfile.lock is invalid" do
      let(:file) do
        File.new("#{Rails.root}/spec/support/fixtures/corrupt.lock")
      end
      let(:file_upload) do
        fixture_file_upload(file)
      end
      let(:msg) do
        "File has contents that are not what they are reported to be. File is invalid. File content type is invalid"
      end

      before do
        post :create, params: { gemfile: { file: file_upload } }
      end

      it "redirects to the homepage" do
        expect(response).to redirect_to(root_path)
      end

      it "loads an error message in flash[:error]" do
        expect(flash[:error]).to eq(msg)
      end
    end
  end

  describe "#show" do
    let(:file) do
      File.new("#{Rails.root}/spec/support/fixtures/Gemfile.lock")
    end
    subject { Gemfile.create(file: file) }

    context "when trying to find gemfile by id" do
      it "won't find any" do
        expect do
          get :show, params: { id: subject.id }
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "when trying to find gemfile by alpha id" do
      let(:message) { "No vulnerabilities found!" }

      it "will find it" do
        get :show, params: { id: subject.alpha_id }

        expect(response).to be_ok
      end
    end
  end
end
