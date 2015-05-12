require 'rails_helper'

RSpec.describe "user profile path" do
  routes { Sufia::Engine.routes }
  it "should be able to accept a user without an email" do
    user = User.new(:username => "banana")

    expect(get edit_profile_path(user)).to route_to :controller => "users", :action => "edit", :id => "banana"
  end
end
