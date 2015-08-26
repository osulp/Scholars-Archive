require 'spec_helper'
require 'rails_helper'

describe GenericFilesController do
  let(:user) { FactoryGirl.create(:joe, :admin) }
  let(:publisher) { 'Oregon State University' }
  let(:language_uri) { 'http://id.loc.gov/vocabulary/iso639-1/en' }
  let(:rights) {'CC0'}
  before do
    allow(controller).to receive(:has_access?).and_return(true)
    sign_in user
  end
  
  describe "#edit" do
    let(:generic_file) do
      GenericFile.create do |gf|
        gf.apply_depositor_metadata(user)
      end
    end

    it "defaults publisher" do
      get :edit, id: generic_file
      expect(response).to be_success
      expect(assigns[:generic_file]).to eq generic_file
      expect(assigns[:form].publisher[0]).to eq publisher
      expect(response).to render_template(:edit)
    end

    it "defaults language" do
      get :edit, id: generic_file
      expect(response).to be_success
      expect(assigns[:generic_file]).to eq generic_file
      expect(assigns[:form].language[0].attributes['id']).to eq language_uri
      expect(response).to render_template(:edit)
    end

    it "defaults rights" do
      get :edit, id: generic_file
      expect(response).to be_success
      expect(assigns[:generic_file]).to eq generic_file
      expect(assigns[:form].rights[0]).to eq rights
      expect(response).to render_template(:edit)
    end
  end
end
