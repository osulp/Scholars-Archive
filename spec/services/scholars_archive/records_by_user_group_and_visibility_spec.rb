require 'spec_helper'
require 'rails_helper'
describe ScholarsArchive::RecordsByUserGroupAndVisibility do
  let(:service) { described_class.new }
  let(:user) { double("Current User") }
  let(:facet) { double("facet") }
  let(:admin_facet_results) { ["bob", "ross", "banana"] }
  let(:admin_solr_search) { "admin_search" }
  let(:other_record_search) { "other_record_search" }
  let(:records) { {"response":{"docs":[]}} }

  describe "#call" do
    context "when an admin user" do
      before do
        allow(user).to receive(:admin?).and_return(true)
        allow(described_class).to receive(:admin_search).with(facet).and_return(admin_solr_search)
        allow(described_class).to receive(:other_owned_records).with(facet, username).and_return(other_record_search)
        allow(ActiveFedora::SolrService).to receive(:get).with(combined_searches, 1000000).and_return(records)
      end
      it "returns all unique creators in an array" do
        let(:combined_searches) { admin_solr_search + " OR " + other_record_search }
        expect(service.call(user, facet)).to eq (admin_facet_results)
      end
    end
  end

end
