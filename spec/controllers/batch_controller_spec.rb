require 'spec_helper'
require 'rails_helper'

RSpec.describe BatchController do
  let(:user) { FactoryGirl.create(:joe, :admin) }
  let(:publisher) { 'Oregon State University' }
  let(:language_uri) { 'http://id.loc.gov/vocabulary/iso639-1/en' }
  before do
    sign_in user
  end

  describe "#edit" do
    before do
      allow_any_instance_of(User).to receive(:display_name).and_return("Joe")
    end
    let(:b1) { Batch.create }

    it "defaults publisher" do
      get :edit, id: b1.id
      expect(assigns[:form]).not_to be_persisted
      expect(assigns[:form].publisher[0]).to eq publisher
    end

    it "defaults language" do
      get :edit, id: b1.id
      expect(assigns[:form]).not_to be_persisted
      expect(assigns[:form].language[0]).to eq language_uri
    end

  end
end
