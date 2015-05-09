require 'rails_helper'

RSpec.describe "help routing" do
  it "should route /help/graduate to help#graduate" do
    expect(get "/help/graduate").to route_to "help#graduate"
  end
end
