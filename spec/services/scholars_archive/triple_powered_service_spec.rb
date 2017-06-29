require 'spec_helper'
require 'rails_helper'
describe ScholarsArchive::TriplePoweredService do
  let(:service) { described_class.new }

  describe "#fetch" do
    before do
      allow(ScholarsArchive::TriplePoweredProperties::Triplestore).to receive(:fetch).with("www.blah.com").and_return(RDF::Graph.new)
      allow(ScholarsArchive::TriplePoweredProperties::Triplestore).to receive(:predicate_labels).with(RDF::Graph.new).and_return({:object1 => ["label1"]})
    end
    it "returns labels for uri" do
      expect(service.fetch(["www.blah.com"])).to eq ["label1$www.blah.com"]
    end
  end
end
