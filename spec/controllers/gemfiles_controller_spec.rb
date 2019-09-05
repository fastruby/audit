require "rails_helper"

RSpec.describe GemfilesController do
  render_views

  let(:file) do
    File.new("#{Rails.root}/spec/support/fixtures/#{gemfile_lock}")
  end
  let(:gemfile_lock) do
    "healthy_Gemfile.lock"
  end
  subject { Gemfile.create(file: file) }

  describe "#create" do
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
        expect(response.body).to include(message)
      end
    end
  end

end
