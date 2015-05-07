require 'rails_helper'

RSpec.describe SessionsController do
  
  let(:user) do
    User.create(:username => "test", :group_list => ["admin", "registered"])
  end
  describe '#destroy' do
    before do
      sign_in(user) if user
      @request.env["devise.mapping"] = Devise.mappings[:user]
      get :destroy
    end
    it "should end the users session" do
      expect(response).to redirect_to(root_path)
    end
  end
end
