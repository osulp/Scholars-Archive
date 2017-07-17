require 'spec_helper'
require 'rails_helper'
describe ScholarsArchive::AdminSetSelectService do
  let(:service) { described_class }

  describe "#select" do
    context "When only one select_option exists" do
      it "returns an admin set" do
        expect(service.select("Article", [["Article", "Article-ID"]])).to eq ["Article", "Article-ID"]
      end
    end

    context "When multiple select_options exist" do
      it "returns the right one" do
        expect(service.select("Article", [["Blah", "Blah-ID"], ["Article", "Article-ID"]])).to eq ["Article", "Article-ID"]
      end
    end

    context "When no matches found" do
      before do
        allow(ENV).to receive(:[]).with("SCHOLARSARCHIVE_DEFAULT_ADMIN_SET").and_return("Default Admin Set")
      end
      it "returns the right one" do
        expect(service.select("Article", [["Blah", "Blah-ID"], ["Blahblah", "Blahblah-ID"]])).to eq ["Default Admin Set"]
      end
    end
  end
end
