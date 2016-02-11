require 'rails_helper'

RSpec.describe ContentBlocksController do 
  let(:researcher) {ContentBlock.create(name: ContentBlock::RESEARCHER)}
  describe "delete" do
    it "should delete a featured_researcher" do
     
      #This is for redirect_to :back
      @request.env['HTTP_REFERER'] = 'localhost:3000/featured_researchers'

      researcher

      expect(ContentBlock.all.length).to eq 1

      get :delete, :id => researcher.id

      expect(ContentBlock.all.length).to eq 0
    end
  end
end
