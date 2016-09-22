require 'rails_helper'

RSpec.describe SolrDocument do
  describe "#nested_geo_points" do
    context "when there are no geo points" do
      it "should return an empty array" do
        document = described_class.new({})
        expect(document.nested_geo_points).to eq []
      end
    end
    context "when there are geo points" do
      it "should return their labels" do
        document = described_class.new({
          "nested_geo_points_label_ssim" => ["Test"]
        })

        expect(document.nested_geo_points).to eq ["Test"]
      end
    end
  end
  describe "#nested_geo_bbox" do
    context "when there are no geo bbox entries" do
      it "should return an empty array" do
        document = described_class.new({})
        expect(document.nested_geo_bbox).to eq []
      end
    end
    context "when there are geo bbox entries" do
      it "should return their labels" do
        document = described_class.new({
          "nested_geo_bbox_label_ssim" => ["Test"]
        })

        expect(document.nested_geo_bbox).to eq ["Test"]
      end
    end
  end
  describe "#nested_geo_location" do
    context "when there are no geo location entries" do
      it "should return an empty array" do
        document = described_class.new({})
        expect(document.nested_geo_location).to eq []
      end
    end
    context "when there are geo location entries" do
      it "should return their labels" do
        document = described_class.new({
          "nested_geo_location_name_ssim" => ["Test"]
        })

        expect(document.nested_geo_location).to eq ["Test"]
      end
    end
  end
  describe "#accepted" do
    context "when there are no date_accepted entries" do
      it "should return an empty array" do
        document = described_class.new({})
        expect(document.accepted).to eq nil
      end
    end
    context "when there are date_accepted entries" do
      it "should return the first label available" do
        document = described_class.new({
          "accepted_tesim" => ["Test"]
        })

        expect(document.accepted).to eq "Test"
      end
    end
  end
  describe "#available" do
    context "when there are no date_available entries" do
      it "should return an empty array" do
        document = described_class.new({})
        expect(document.available).to eq nil
      end
    end
    context "when there are date_available entries" do
      it "should return the first label available" do
        document = described_class.new({
          "available_tesim" => ["Test"]
        })

        expect(document.available).to eq "Test"
      end
    end
  end
  describe "#copyrighted" do
    context "when there are no date_copyrighted entries" do
      it "should return an empty array" do
        document = described_class.new({})
        expect(document.copyrighted).to eq nil
      end
    end
    context "when there are date_available entries" do
      it "should return the first label available" do
        document = described_class.new({
          "copyrighted_tesim" => ["Test"]
        })

        expect(document.copyrighted).to eq "Test"
      end
    end
  end
  describe "#collected" do
    context "when there are no date_collected entries" do
      it "should return an empty array" do
        document = described_class.new({})
        expect(document.collected).to eq nil
      end
    end
    context "when there are date_available entries" do
      it "should return the first label available" do
        document = described_class.new({
          "collected_tesim" => ["Test"]
        })

        expect(document.collected).to eq "Test"
      end
    end
  end
  describe "#issued" do
    context "when there are no date_issued entries" do
      it "should return an empty array" do
        document = described_class.new({})
        expect(document.issued).to eq nil
      end
    end
    context "when there are date_available entries" do
      it "should return the first label available" do
        document = described_class.new({
          "issued_tesim" => ["Test"]
        })

        expect(document.issued).to eq "Test"
      end
    end
  end
  describe "#valid" do
    context "when there are no date_valid entries" do
      it "should return an empty array" do
        document = described_class.new({})
        expect(document.valid).to eq nil
      end
    end
    context "when there are date_available entries" do
      it "should return the first label available" do
        document = described_class.new({
          "valid_tesim" => ["Test"]
        })

        expect(document.valid).to eq "Test"
      end
    end
  end
end
