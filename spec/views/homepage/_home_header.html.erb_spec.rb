require 'rails_helper'

RSpec.describe "homepage/_home_header.html.erb" do
  let(:user) {}
  before do
    sign_in(user) if user
    stub_template("_marketing" => "marketing")
    render
  end
  context "when visiting the root path as a guest/registered user" do
    it "should display the Browse Uploaded Work button" do
      expect(rendered).to have_content("Browse Uploaded Content")
    end
  end
  context "when visiting the root path as an admin" do
    let(:user) do
      User.create(:username => "test", :group_list => "admin")
    end 
    it "should display the Browse Uploaded Work button" do
      expect(rendered).to have_content("Share Your Work")
      expect(rendered).not_to have_content("Browse Uploaded Work")
    end
  end
  
end
