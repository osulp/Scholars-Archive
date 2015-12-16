require 'rails_helper'

RSpec.describe SolrDocument do
  describe "#nested_authors" do
    context "when there are no authors" do
      it "should return an empty array" do
        document = described_class.new({})
        
        expect(document.nested_authors).to eq []
      end
    end
    context "when there are authors" do
      it "should return their names" do
        document = described_class.new({
          "nested_authors_label_ssim" => ["Test"]
        })

        expect(document.nested_authors).to eq ["Test"]
      end
    end
  end

  describe "#tag_list" do
    let(:water) { Hash["id" => "http://id.loc.gov/authorities/subjects/sh85145447", "preflabel" => "Water"] }
    let(:fire) { Hash["id" => "http://id.loc.gov/authorities/subjects/sh85048449", "preflabel" => "Fire"] }
    context "when there are no uri tags" do
      it "should return an empty array" do
        document = described_class.new({})
        allow(document).to receive(:tag_list) { [] }
        expect(document.tag_list).to eq []
      end
    end
    context "when there are uri tags" do
      it "should return an an array of tags with labels" do
        document = described_class.new({})
        allow(document).to receive(:tag_list) { [water, fire] }
        expect(document.tag_list).to eq [water, fire]
        expect(document.tag_list.count).to eq 2
        expect(document.tag_list.first['preflabel']).to eq "Water"
        expect(document.tag_list.second['preflabel']).to eq "Fire"
      end
    end
  end
end
