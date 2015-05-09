require 'rails_helper'

RSpec.describe "help routing" do
  it "should route /help/faculty to help#faculty" do
    expect(get "/help/faculty").to route_to "help#faculty"
  end
end
