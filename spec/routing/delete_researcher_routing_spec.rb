require 'rails_helper'

RSpec.describe "destroy featured researcher route" do
  it "routes /featured_researcher/:id/delete" do
    expect(delete("/featured_researcher/1/delete")).to route_to({
      "controller" => "content_blocks",
      "action" => "destroy",
      "id" => "1"
    })
  end
end
