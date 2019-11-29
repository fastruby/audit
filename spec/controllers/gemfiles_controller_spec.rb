require "rails_helper"

RSpec.describe GemfilesController do
  render_views

  let(:file) do
    File.new("#{Rails.root}/spec/support/fixtures/Gemfile.lock")
  end
  subject { Gemfile.create(file: file) }

  describe "#show" do
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
