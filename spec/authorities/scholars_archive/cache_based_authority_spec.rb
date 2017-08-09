require 'rails_helper'

RSpec.describe ScholarsArchive::CacheBasedAuthority  do
  let(:authority) { described_class.new("academic_units") }
  let(:parser) { Parsers::AcademicUnitsParser }

  describe "#terms" do
    before do
      allow(YAML).to receive(:load).with(File.read(File.join(Rails.root, "config/authorities.yml"))).and_return({academic_units: { uri: "blah", cache_expires_in_hours: 24, parser: "Parsers::AcademicUnitsParser" }})
      allow(ScholarsArchive::CachingService).to receive(:fetch_or_store_in_cache).with("blah", 24).and_return("Some Valid Json")
      allow(parser).to receive(:parse).with("Some Valid Json").and_return([{id: "http://opaquenamespace.org/ns/osuAcademicUnits/0Ct5bACm", term: "Forestry", active: true}])
    end
    context "When terms is called" do
      it "should return an array of the properly formatted terms" do
        expect(authority.all).to eq [{"id"=>"http://opaquenamespace.org/ns/osuAcademicUnits/0Ct5bACm","label"=>"Forestry","active"=>true}]
      end
    end
  end
end
