# Generated via
#  `rails generate curation_concerns:work GenericWork`
require 'rails_helper'

describe CurationConcerns::GenericWorkForm do
  let(:work) { GenericWork.new }
  let(:form) { described_class.new(work, nil) }

  describe ".build_permitted_params" do
    it "should permit nested author attributes" do
      expect(described_class.build_permitted_params).to include(
        {
          :nested_geo_points_attributes => [
            :label,
            :latitude,
            :longitude,
            :id,
            :_destroy
          ]
        }
      )

      expect(described_class.build_permitted_params).to include(
          :nested_geo_bbox_attributes => [
            :label,
            :bbox,
            :id,
            :_destroy
          ]
      )

      expect(described_class.build_permitted_params).to include(
          :nested_geo_location_attributes => [
            :id,
            :_destroy,
            :name,
            :geonames_url
          ]
      )
    end
  end

  describe "field instantiation" do
    it "should build a nested field" do
      form
      expect(form.model.nested_geo_points.length).to eq 1
    end
  end

end
