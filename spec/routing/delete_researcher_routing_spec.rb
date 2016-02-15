require 'rails_helper'

RSpec.describe "destroy featured researcher route" do
  it "routes /featured_researcher/:id/delete" do
    expect(delete("featured_researchers/1/delete")).to route_to({
      "controller" => "delete_featured_researchers",
      "action" => "destroy",
      "id" => "1"
    })
  end
end
