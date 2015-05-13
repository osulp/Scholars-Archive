require 'rails_helper'

RSpec.describe "help routing" do
  it "should route /help/something to help#page" do
    expect(get "/help/something").to route_to "help#page", :page => "something"
  end
  it "should route /help to help#page" do
    expect(get "/help").to route_to "help#page", :page => "general"
  end
end
