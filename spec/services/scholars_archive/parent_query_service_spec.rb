require 'spec_helper'
require 'rails_helper'
describe ScholarsArchive::ParentQueryService do
  let(:parent_doc){{"response":{"docs":[{"id": "asdf"}]}}.stringify_keys}
  let(:empty_results){{"response":{"docs":[]}}.stringify_keys}
  let(:child_id) {"child_id"}
  describe "#query_parents_for_id" do
    before do
      allow(ActiveFedora::SolrService).to receive(:get).with("member_ids_ssim:#{child_id}", rows: 100000).and_return(parent_doc)
    end
    context "when a child work exists with a parent" do
      it "returns the parent works" do
        expect(described_class.query_parents_for_id(child_id).length).to eq 1
      end
    end
    before do
      allow(ActiveFedora::SolrService).to receive(:get).with("member_ids_ssim:#{child_id}", rows: 100000).and_return(empty_results)
    end
    context "when a work exists without a parent" do
      it "returns an empty array" do
        expect(described_class.query_parents_for_id(child_id).length).to eq 0
      end
    end
  end
end
