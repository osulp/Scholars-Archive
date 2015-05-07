require 'rails_helper'

RSpec.describe "destroy user session" do
  let(:user) do
    User.create(:username => "test", :group_list => ["registered","admin"])
  end 
  context "when signed in as a user" do
    it "routes /users/sign_out to devise/sessions#destroy" do
      expect(get("/users/sign_out")).to route_to("sessions#destroy")
    end
  end
end
