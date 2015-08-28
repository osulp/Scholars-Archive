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
end
