# Generated via
#  `rails generate hyrax:work DefaultWork`
require 'rails_helper'
require 'spec_helper'

RSpec.describe DefaultWork do
  describe "#nested_geo_attributes" do
    let(:attributes) do
      [{
           :label => "Salem",
           :point => "[44.9430556,-123.0338889]"
       }]
    end
    it "should be able to delete items" do
      g = described_class.new(title: ['test'], keyword: ['test'])
      g.nested_geo_attributes = attributes
      g.save!(:validate => false)
      g.nested_geo_attributes = [
          {
              :id => g.nested_geo.first.id,
              :_destroy => true
          },
          {
              :label => "Banana"
          }
      ]
      g.save!(:validate => false)
      g.reload

      expect(g.nested_geo.length).to eq 1
      expect(g.nested_geo.first.label).to eq ["Banana"]
    end
    it "should work on already persisted items" do
      g = described_class.new.tap{|x| x.save(:validate => false)}
      g.nested_geo_attributes = attributes

      g.save!(:validate => false)
      g.reload

      expect(g.nested_geo.first.label).to eq ["Salem"]
    end
    it "should be able to edit" do
      g = described_class.new(title: ['test'], keyword: ['test'])
      g.nested_geo_attributes = attributes
      g.save!(:validate => false)
      g.nested_geo_attributes = [
          {
              :id => g.nested_geo.first.id,
              :label => "Banana"
          }
      ]
      g.save!(:validate => false)
      g.reload

      expect(g.nested_geo.length).to eq 1
      expect(g.nested_geo.first.label).to eq ["Banana"]
    end
    it "should not create blank ones" do
      g = described_class.new(title: ['test'], keyword: ['test'])
      g.nested_geo_attributes = [
          {
              :label => "",
              :point => "",
          }
      ]
      expect(g.nested_geo.length).to eq 0
    end
  end
  it "should be able to create multiple nested geo points" do
    g = described_class.new(title: ['test'], keyword: ['test'])
    g.nested_geo_attributes = [
        {
            "label" => "1"
        },
        {
            "label" => "2"
        }
    ]

    g.save!(:validate => false)
    g.reload

    expect(g.nested_geo.length).to eq 2
    expect(g.nested_geo.map{|x| x.label.first}).to contain_exactly("1","2")
  end
  describe "#attributes=" do
    it "accepts nested attributes" do
      g = described_class.new(title: ['test'], keyword: ['test'])
      g.attributes = {
          :nested_geo_attributes => [
              {
                  :label => "Salem",
                  :point => "[44.9430556,-123.0338889]"
              }
          ]
      }

      g.save!(:validate => false)
      g.reload

      expect(g.nested_geo.first.label).to eq ["Salem"]
    end
  end
end

