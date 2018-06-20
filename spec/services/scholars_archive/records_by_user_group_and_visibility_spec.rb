require 'spec_helper'
require 'rails_helper'
describe ScholarsArchive::RecordsByUserGroupAndVisibility do
  let(:service) { described_class.new }
  let(:user) { double("Current User") }
  let(:facet) { double("facet") }
  let(:username) { "CoolGuy" }
  let(:admin_facet_results) { ["bob", "ross", "banana"] }
  let(:guest_facet_results) { ["bob", "ross"] }
  let(:auth_facet_results) { ["bob"] }
  let(:admin_solr_search) { "admin_search" }
  let(:guest_solr_search) { "guest_search" }
  let(:auth_solr_search) { "auth_search" }
  let(:other_record_search) { "other_record_search" }
  let(:facet_key) { "creator_sim" }
  let(:combined_searches) { "" }

  describe "#call" do
    before do
      allow(user).to receive(:groups).and_return(["group"])
      allow(user).to receive(:username).and_return(username)
      allow(facet).to receive(:key).and_return(facet_key)
    end
    context "when an admin user" do
      let(:combined_searches) { admin_solr_search + " OR " + other_record_search }
      before do
        allow(user).to receive(:admin?).and_return(true)
        allow(user).to receive(:guest?).and_return(false)
        allow(service).to receive(:admin_search).with(facet).and_return(admin_solr_search)
        allow(service).to receive(:other_owned_records).with(facet, username).and_return(other_record_search)
        allow(service).to receive(:facets).with(anything(), anything()).and_return(admin_facet_results)
      end
      it "returns all unique creators in an array" do
        expect(service.call(user, facet)).to eq (admin_facet_results)
      end
    end
    context "when a guest user" do
      let(:combined_searches) { guest_solr_search + " OR " + other_record_search }
      before do
        allow(user).to receive(:admin?).and_return(false)
        allow(user).to receive(:guest?).and_return(true)
        allow(service).to receive(:admin_search).with(facet).and_return(guest_solr_search)
        allow(service).to receive(:other_owned_records).with(facet, username).and_return(other_record_search)
        allow(service).to receive(:facets).with(anything(), anything()).and_return(guest_facet_results)
      end
      it "returns all unique creators in an array" do
        expect(service.call(user, facet)).to eq (guest_facet_results)
      end
    end
    context "when an auth user" do
      let(:combined_searches) { auth_solr_search + " OR " + other_record_search }
      before do
        allow(user).to receive(:admin?).and_return(false)
        allow(user).to receive(:guest?).and_return(false)
        allow(service).to receive(:admin_search).with(facet).and_return(auth_solr_search)
        allow(service).to receive(:other_owned_records).with(facet, username).and_return(other_record_search)
        allow(service).to receive(:facets).with(anything(), anything()).and_return(auth_facet_results)
      end
      it "returns all unique creators in an array" do
        expect(service.call(user, facet)).to eq (auth_facet_results)
      end
    end
  end
end
