require 'spec_helper'
require 'rails_helper'
describe ScholarsArchive::AllVisibleFacetsService do
  let(:service) { described_class.new }
  let(:facet) { double("facet") }
  let(:facet_results) { ["bob", "ross", "banana"] }
  let(:facet_key) { "creator_sim" }

  describe "#call" do
    before do
      allow(facet).to receive(:key).and_return(facet_key)
      allow(service).to receive(:facets).with(anything(), anything()).and_return(facet_results)
    end
    it "returns all unique creators in an array" do
      expect(service.call(user, facet)).to eq (admin_facet_results)
    end
  end
end
