require 'rails_helper'

RSpec.describe SolrDocument do
  describe "#academic_affiliation_label" do
    context "when an academic_affiliation_label is indexed" do
      document = described_class.new({
                                        "academic_affiliation_label_ssim" => ["label1$www.blah.com"]
                                     })
      it "should return the label" do
        expect(document.academic_affiliation_label).to eq [{"label"=>"label1", "uri"=>"www.blah.com"}]
      end
    end
  end

  describe "#other_affiliation_label" do
    context "when an other_affiliation_label is indexed" do
      document = described_class.new({
                                        "other_affiliation_label_ssim" => ["label1$www.blah.com"]
                                     })
      it "should return the label" do
        expect(document.other_affiliation_label).to eq [{"label"=>"label1", "uri"=>"www.blah.com"}]
      end
    end
  end


  describe "#nested_geo" do
    context "when there are no geo points" do
      it "should return an empty array" do
        document = described_class.new({
                                           "nested_geo_label_ssim" => []
                                       })
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

  describe "#nested_related_items" do
    context "when there are no geo points" do
      it "should return an empty array" do
        document = described_class.new({
                                           "nested_related_items_label_ssim" => []
                                       })
        expect(document.nested_related_items).to eq []
      end
    end
    context "when there are related items" do
      it "should return their labels" do
        document = described_class.new({
                                           "nested_related_items_label_ssim" => ["label1$www.blah.com"]
                                       })
        expect(document.nested_related_items).to eq [{'label'=>'label1', 'uri'=>'www.blah.com'}]
      end
    end
  end
end
