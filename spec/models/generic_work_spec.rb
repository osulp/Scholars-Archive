require 'rails_helper'

RSpec.describe GenericWork do
  describe "#nested_geo_points_attributes" do
    let(:attributes) do
      {
        "0" => {
          :label => "Salem",
          :latitude => "44.9430556",
          :longitude => "-123.0338889"
        }
      }

    end
    it "should be able to delete items" do
      g = described_class.new
      g.nested_geo_points_attributes = attributes
      g.save!(:validate => false)
      g.nested_geo_points_attributes = {
        "0" => {
          :id => g.nested_geo_points.first.id,
          :_destroy => true
        },
        "1" => {
          :label => "Banana"
        }
      }
      g.save!(:validate => false)
      g.reload

      expect(g.nested_geo_points.length).to eq 1
      expect(g.nested_geo_points.first.label).to eq ["Banana"]
    end
    it "should work on already persisted items" do
      g = described_class.new.tap{|x| x.save(:validate => false)}
      g.nested_geo_points_attributes = attributes

      g.save!(:validate => false)
      g.reload

      expect(g.nested_geo_points.first.label).to eq ["Salem"]
    end
    it "should be able to edit" do
      g = described_class.new
      g.nested_geo_points_attributes = attributes
      g.save!(:validate => false)
      g.nested_geo_points_attributes = {
        "0" => {
          :id => g.nested_geo_points.first.id,
          :label => "Banana"
        }
      }
      g.save!(:validate => false)
      g.reload

      expect(g.nested_geo_points.length).to eq 1
      expect(g.nested_geo_points.first.label).to eq ["Banana"]
    end
    it "should not create blank ones" do
      g = described_class.new
      g.nested_geo_points_attributes = {
        "0" => {
          :label => "",
          :latitude => "",
          :longitude => "",
          :orcid => ""
        }
      }
      expect(g.nested_geo_points.length).to eq 0
    end
  end
  it "should be able to create multiple nested geo points" do
    g = described_class.new
    g.nested_geo_points_attributes = {
      "0" => {
        "label" => "1"
      },
      "1" => {
        "label" => "2"
      }
    }

    g.save!(:validate => false)
    g.reload

    expect(g.nested_geo_points.length).to eq 2
    expect(g.nested_geo_points.map{|x| x.label.first}).to contain_exactly("1","2")
  end
  describe "#attributes=" do
    it "accepts nested attributes" do
      g = described_class.new
      g.attributes = {
        :nested_geo_points_attributes => [
          {
            :label => "Salem",
            :latitude => "44.9430556",
            :longitude => "-123.0338889"
          }
        ]
      }

      g.save!(:validate => false)
      g.reload

      expect(g.nested_geo_points.first.label).to eq ["Salem"]
    end
  end
end
