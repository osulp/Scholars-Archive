require 'rails_helper'

RSpec.describe "destroy featured researcher route" do
  it "routes /featured_researcher/:id" do
    expect(get("/featured_researcher/1")).to route_to({
      "controller" => "content_blocks",
      "action" => "delete",
      "id" => "1"
    })
  end
end
