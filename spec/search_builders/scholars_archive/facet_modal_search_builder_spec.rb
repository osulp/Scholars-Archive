require 'spec_helper'
require 'rails_helper'
describe ScholarsArchive::FacetModalSearchBuilder do
  let(:search_builder) { described_class.new }
  let(:facet_string) { "creator_sim" }
  let(:group) { "admin" }
  let(:visibility) { "open" }
  let(:username) { "bobross" }

  describe "#admin_records" do
    it "returns a string with the facet and without filesets" do
      expect(search_builder.admin_records(facet_string)).to eq "(creator_sim:* AND -has_model_ssim:FileSet)"
    end
  end

  describe "#group_records" do
    it "returns a string with the facet and without filesets" do
      expect(search_builder.group_records(facet_string, group, visibility)).to eq "(creator_sim:* AND read_access_group_ssim:admin AND visibility_ssi:open AND -has_model_ssim:FileSet)"
    end
  end

  describe "#edit_access_records" do
    it "returns a string with the facet and without filesets" do
      expect(search_builder.edit_access_records(facet_string, username)).to eq "(creator_sim:* AND edit_access_person_ssim:bobross AND -has_model_ssim:FileSet)"
    end
  end
end
