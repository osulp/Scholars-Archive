# Generated via
#  `rails generate hyrax:work DefaultWork`
require 'rails_helper'
require 'spec_helper'

RSpec.describe Default do
  describe "date facet yearly" do
    let(:asset) {
      g = described_class.new(title: ['test'], keyword: ['test'])
      g.attributes = {
          :date_created => date
      }
      g
    }
    let(:date) { "2022-01-01" }
    let(:facet) { asset.to_solr["date_facet_yearly_ssim"] }

    context "when given date is nil" do
      let(:asset) do
        g = described_class.new(title: ['test'], keyword: ['test'])
        g.attributes = {
            :date_created => nil
        }
        g
      end
      it "should be blank" do
        expect(facet).to be_nil
      end
    end
    context "when given an invalid date" do
      let(:asset) do
        g = described_class.new(title: ['test'], keyword: ['test'])
        g.attributes = {
            :date_created => "typo2011-01-01"
        }
        g
      end
      it "should be blank" do
        expect(facet).to be_nil
      end
    end
    context "when given a date" do
      it "should be that year" do
        expect(facet).to eq [2022]
      end
    end
    context "when given just a year" do
      let(:date) { "2011" }
      it "should pull the year" do
        expect(facet).to eq [2011]
      end
    end
    context "when given a date range" do
      context "when is a range of dates YYYY-mm-dd/YYY-mm-dd" do
        let(:date) { "1925-12-01/1927-01-01" }
        it "should have years in that range" do
          expect(facet).to eq [1925,1926,1927]
        end
      end
      context "when is a range of years only YYYY/YYYY" do
        let(:date) { "2014/2017" }
        it "should have years in that range" do
          expect(facet).to eq [2014,2015,2016,2017]
        end
      end
      context "when is a range of year and month only YYYY-mm/YYY-mm" do
        let(:date) { "2017-12/2018-01" }
        it "should have years in that range" do
          expect(facet).to eq [2017,2018]
        end
      end
    end
  end
  describe "decade facets" do
    let(:asset) {
      g = described_class.new(title: ['test'], keyword: ['test'])
      g.attributes = {
          :date_created => date
      }
      g
    }
    let(:date) { "2022-01-01" }
    let(:facet) { asset.to_solr["date_decades_ssim"] }
    context "when no date" do
      context "and no other usable date" do
        let(:asset) do
          g = described_class.new(title: ['test'], keyword: ['test'])
          g.attributes = {
              :date_created => nil
          }
          g
        end
        it "should be blank" do
          expect(facet).to be_nil
        end
      end
      context "but date_created present" do
        let(:asset) do
          g = described_class.new(title: ['test'], keyword: ['test'])
          g.attributes = {
              :date_created => date_created
          }
          g
        end
        let(:date_created) { "1973-03-09" }
        it "should be that decade" do
          expect(facet).to eq ["1970-1979"]
        end
      end
      context "but copyright date present" do
        let(:asset) do
          g = described_class.new(title: ['test'], keyword: ['test'])
          g.attributes = {
              :date_copyright => date_copyright
          }
          g
        end
        let(:date_copyright) { "1943" }
        it "should be that decade" do
          expect(facet).to eq ["1940-1949"]
        end
      end
      context "but copyright date present" do
        let(:asset) do
          g = described_class.new(title: ['test'], keyword: ['test'])
          g.attributes = {
              :date_issued => date_issued
          }
          g
        end
        let(:date_issued) { "1943" }
        it "should be that decade" do
          expect(facet).to eq ["1940-1949"]
        end
      end
    end
    context "when given a date" do
      it "should be that decade" do
        expect(facet).to eq ["2020-2029"]
      end
    end
    context "when given just a year" do
      let(:date) { "2011" }
      it "should pull the date" do
        expect(facet).to eq ["2010-2019"]
      end
    end
    context "when given a date range" do
      context "when is in a single decade" do
        let(:date) { "1910-1915" }
        it "should have only one entry" do
          expect(facet).to eq ["1910-1919"]
        end
      end
      context "which spans decades" do
        let(:date) { "1910-1920" }
        it "should have two entries" do
          expect(facet).to eq ["1910-1919", "1920-1929"]
        end
        context "which is more than 30 years" do
          let(:date) { "1900-1940" }
          it "should be blank" do
            expect(facet).to be_nil
          end
        end
      end
    end
  end
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
      g.nested_geo_attributes = [
          {
              :id => g.nested_geo.first.id,
              :_destroy => true
          },
          {
              :label => "Banana"
          }
      ]
      expect(g.nested_geo.length).to eq 1
      expect(g.nested_geo.first.label).to eq ["Banana"]
    end
    it "should work on already persisted items" do
      g = described_class.new(title: ['test'], keyword: ['test'])
      g.nested_geo_attributes = attributes
      expect(g.nested_geo.first.label).to eq ["Salem"]
    end
    it "should be able to edit" do
      g = described_class.new(title: ['test'], keyword: ['test'])
      g.nested_geo_attributes = attributes
      expect(g.nested_geo.length).to eq 1
      expect(g.nested_geo.first.label).to eq ["Salem"]

      g.nested_geo.first.label = ["Banana"]
      g.nested_geo.first.persist!
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
    expect(g.nested_geo.length).to eq 2
    expect(g.nested_geo.map{|x| x.label.first}).to contain_exactly("1","2")
  end

  describe "#nested_ordered_creator_attributes" do
    let(:attributes) do
      [{
           :index => "0",
           :creator => "CreatorA"
       }]
    end
    it "should be able to delete items" do
      g = described_class.new(title: ['test'])
      g.nested_ordered_creator_attributes = attributes
      g.nested_ordered_creator_attributes = [
          {
              :id => g.nested_ordered_creator.first.id,
              :_destroy => true
          },
          {
              :index => "1",
              :creator => "CreatorB"
          }
      ]
      expect(g.nested_ordered_creator.length).to eq 1
      expect(g.nested_ordered_creator.first.creator).to eq ["CreatorB"]
    end
    it "should not persist items when all are blank" do
      g = described_class.new(title: ['test1'])
      g.nested_ordered_creator_attributes = [
          {
              :index => "",
              :creator => ""
          },
          {
              :index => "",
              :creator => ""
          }
      ]
      expect(g.nested_ordered_creator.length).to eq 0
    end
    it "should not persist items when either one of the attributes are blank" do
      g = described_class.new(title: ['test1'])
      g.nested_ordered_creator_attributes = [
          {
              :index => "",
              :creator => "CreatorA"
          },
          {
              :index => "1",
              :creator => ""
          }
      ]
      expect(g.nested_ordered_creator.length).to eq 0
    end
    it "should work on already persisted items" do
      g = described_class.new(title: ['test'])
      g.nested_ordered_creator_attributes = attributes
      expect(g.nested_ordered_creator.first.creator).to eq ["CreatorA"]
    end
    it "should be able to edit" do
      g = described_class.new(title: ['test'])
      g.nested_ordered_creator_attributes = attributes
      expect(g.nested_ordered_creator.length).to eq 1
      expect(g.nested_ordered_creator.first.creator).to eq ["CreatorA"]

      g.nested_ordered_creator.first.creator = ["CreatorB"]
      g.nested_ordered_creator.first.persist!
      expect(g.nested_ordered_creator.length).to eq 1
      expect(g.nested_ordered_creator.first.creator).to eq ["CreatorB"]
    end
    it "should not create blank ones" do
      g = described_class.new(title: ['test'], keyword: ['test'])
      g.nested_ordered_creator_attributes = [
          {
              :index => "",
              :creator => "",
          }
      ]
      expect(g.nested_ordered_creator.length).to eq 0
    end
  end

  it "should be able to create multiple nested ordered creators" do
    g = described_class.new(title: ['test'])
    g.nested_ordered_creator_attributes = [
        {
          "index" => "0",
          "creator" => "Creator1"
        },
        {
          "index" => "1",
          "creator" => "Creator2"
        }
    ]
    expect(g.nested_ordered_creator.length).to eq 2
    expect(g.nested_ordered_creator.map{|x| x.index.first}).to contain_exactly("0","1")
    expect(g.nested_ordered_creator.map{|x| x.creator.first}).to contain_exactly("Creator1","Creator2")
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
      expect(g.nested_geo.first.label).to eq ["Salem"]
    end
  end
  describe 'visibility' do
    it 'is set to open (public) by default' do
      g = described_class.new(title: ['test'], keyword: ['test'])
      expect(g.visibility).to eq 'open'
    end
  end
end
