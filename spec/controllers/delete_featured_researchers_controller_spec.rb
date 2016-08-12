require 'rails_helper'

RSpec.describe DeleteFeaturedResearchersController do 
  let(:researcher) {ContentBlock.create(name: ContentBlock::RESEARCHER)}
  describe "delete" do
    context "as an admin" do
      let(:user) do 
        r = Role.create name: "admin"
        u = User.create(:username => 'blah')
        r.users << u
        r.save
      end

      before do
        sign_in(user) if user
      end

      it "should delete a featured_researcher" do

        #This is for redirect_to :back
        @request.env['HTTP_REFERER'] = 'localhost:3000/featured_researchers'

        researcher

        expect(ContentBlock.all.length).to eq 1

        get :destroy, :id => researcher.id

        expect(ContentBlock.all.length).to eq 0
      end
    end
    context "as a non-admin" do
      let(:user) {}
      before do
        sign_in(user) if user
      end
      it "should not delete a featured_researcher" do

        #This is for redirect_to :back
        @request.env['HTTP_REFERER'] = 'localhost:3000/featured_researchers'

        researcher

        expect(ContentBlock.all.length).to eq 1

        get :destroy, :id => researcher.id

        expect(ContentBlock.all.length).to eq 1
      end
    end
  end
end
