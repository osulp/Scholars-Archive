require 'rails_helper'

RSpec.describe ScholarsArchive::CacheBasedAuthority  do
  let(:authority) { described_class.new("academic_units") }
  let(:parser) { Parsers::AcademicUnitsParser }

  describe "#terms" do
    before do
      allow(YAML).to receive(:load).with(":local_path: \"config/authorities\"\nacademic_units:\n  uri: 'http://opaquenamespace.org/ns/osuAcademicUnits.jsonld'\n  cache_expires_in: 1.day\n  parser: Parsers::AcademicUnitsParser\n").and_return({academic_units: { uri: "blah", cache_expires_in: 10.minutes, parser: "Parsers::AcademicUnitsParser" }})
      allow(ScholarsArchive::CachingService).to receive(:fetch_or_store_in_cache).with("blah", 10.minutes).and_return("Some Valid Json")
      allow(parser).to receive(:parse).with("Some Valid Json").and_return([{id: "http://opaquenamespace.org/ns/osuAcademicUnits/0Ct5bACm", term: "Forestry", active: true}])
    end
    context "When terms is called" do
      it "should return an array of the properly formatted terms" do
        expect(authority.all).to eq [{"id"=>"http://opaquenamespace.org/ns/osuAcademicUnits/0Ct5bACm","label"=>"Forestry","active"=>true}]
      end
    end
  end
end
