require 'rails_helper'

RSpec.describe SolrDocument do
  describe "#academic_affiliation_label" do
    context "when an academic_affiliation_label is indexed" do
      document = described_class.new({
                                        "academic_affiliation_label_ssim" => ["label1$www.blah.com"]
                                     })
      it "should return the label" do
        expect(document.academic_affiliation_label).to eq ["label1"]
      end
    end
  end

  describe "#other_affiliation_label" do
    context "when an other_affiliation_label is indexed" do
      document = described_class.new({
                                        "other_affiliation_label_ssim" => ["label1$www.blah.com"]
                                     })
      it "should return the label" do
        expect(document.other_affiliation_label).to eq ["label1"]
      end
    end
  end


  describe "#nested_geo" do
    context "when there are no geo points" do
      it "should return an empty array" do
        document = described_class.new({
                                           "nested_geo_label_tesim" => []
                                       })
        expect(document.nested_geo).to eq []
      end
    end
    context "when there are geo coordinates" do
      it "should return their labels" do
        document = described_class.new({
                                           "nested_geo_label_tesim" => ["Test"]
                                       })
        expect(document.nested_geo).to eq ["Test"]
      end
    end
  end
end
