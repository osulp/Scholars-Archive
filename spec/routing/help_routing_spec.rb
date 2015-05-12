require 'rails_helper'

RSpec.describe "help routing" do
  it "should route /help/faculty to help#faculty" do
    expect(get "/help/faculty").to route_to "help#faculty"
  end
  it "should route /help/graduate to help#graduate" do
    expect(get "/help/graduate").to route_to "help#graduate"
  end
  it "should route /help/undergraduate to help#undergraduate" do
    expect(get "/help/undergraduate").to route_to "help#undergraduate"
  end
  it "should rout /help to help#general" do
    expect(get "/help").to route_to "help#general"
  end
end
