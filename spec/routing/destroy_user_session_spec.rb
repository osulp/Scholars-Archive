require 'rails_helper'

RSpec.describe "destroy user session" do
  context "when signed in as a user" do
    it "routes /users/sign_out to devise/sessions#destroy" do
      expect(get("/users/sign_out")).to route_to("sessions#destroy")
    end
  end
end
