require 'rails_helper'

RSpec.describe "help routing" do
  it "should route /help/undergraduate to help#undergraduate" do
    expect(get "/help/undergraduate").to route_to "help#undergraduate"
  end

end
