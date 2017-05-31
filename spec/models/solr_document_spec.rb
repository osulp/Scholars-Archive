require 'rails_helper'

RSpec.describe SolrDocument do
  describe "#nested_geo" do
    context "when there are no geo points" do
      it "should return an empty array" do
        document = described_class.new({})
        expect(document.nested_geo).to eq []
      end
    end
    context "when there are geo coordinates" do
      it "should return their labels" do
        document = described_class.new({
          "nested_geo_label_ssim" => ["Test"]
                                       })
        expect(document.nested_geo).to eq ["Test"]
      end
    end
  end
end