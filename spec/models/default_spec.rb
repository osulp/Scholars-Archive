# Generated via
#  `rails generate hyrax:work DefaultWork`
require 'rails_helper'
require 'spec_helper'

RSpec.describe Default do
  let(:nested_ordered_title_attributes) do
    [
      {
        :title => "TestTitle",
        :index => "0"
      }
    ]
  end
  describe "date facet yearly" do
    let(:asset) {
      g = described_class.new(keyword: ['test'])
      g.attributes = {
        :date_created => date,
        :nested_ordered_title_attributes => nested_ordered_title_attributes
      }
      g
    }

    let(:date) { "2022-01-01" }
    let(:facet) { asset.to_solr["date_facet_yearly_ssim"] }

    context "when given date is nil" do
      let(:asset) do
        g = described_class.new(keyword: ['test'])
        g.attributes = {
            :date_created => nil,
            :nested_ordered_title_attributes => nested_ordered_title_attributes
        }
        g
      end
      it "should be blank" do
        expect(facet).to be_nil
      end
    end
    context "when given an invalid date" do
      let(:asset) do
        g = described_class.new(keyword: ['test'])
        g.attributes = {
            :date_created => "typo2011-01-01",
            :nested_ordered_title_attributes => [
              {
                :title => "TestTitle",
                :index => "0"
              }
            ]
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
      g = described_class.new(keyword: ['test'])
      g.attributes = {
          :date_created => date,
          :nested_ordered_title_attributes => nested_ordered_title_attributes
      }
      g
    }
    let(:date) { "2022-01-01" }
    let(:facet) { asset.to_solr["date_decades_ssim"] }
    context "when no date" do
      context "and no other usable date" do
        let(:asset) do
          g = described_class.new(keyword: ['test'])
          g.attributes = {
              :date_created => nil,
              :nested_ordered_title_attributes => nested_ordered_title_attributes
          }
          g
        end
        it "should be blank" do
          expect(facet).to be_nil
        end
      end
      context "but date_created present" do
        let(:asset) do
          g = described_class.new(keyword: ['test'])
          g.attributes = {
              :date_created => date_created,
              :nested_ordered_title_attributes => nested_ordered_title_attributes

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
          g = described_class.new(keyword: ['test'])
          g.attributes = {
              :date_copyright => date_copyright,
              :nested_ordered_title_attributes => nested_ordered_title_attributes
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
          g = described_class.new(keyword: ['test'])
          g.attributes = {
              :date_issued => date_issued,
              :nested_ordered_title_attributes => nested_ordered_title_attributes
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
      g = described_class.new(keyword: ['test'])
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

      g.nested_ordered_title_attributes = nested_ordered_title_attributes

      expect(g.nested_geo.length).to eq 1
      expect(g.nested_geo.first.label).to eq ["Banana"]
    end
    it "should work on already persisted items" do
      g = described_class.new(keyword: ['test'])
      g.nested_geo_attributes = attributes
      g.nested_ordered_title_attributes = nested_ordered_title_attributes
      expect(g.nested_geo.first.label).to eq ["Salem"]
    end
    it "should be able to edit" do
      g = described_class.new(keyword: ['test'])
      g.nested_geo_attributes = attributes
      g.nested_ordered_title_attributes = nested_ordered_title_attributes
      expect(g.nested_geo.length).to eq 1
      expect(g.nested_geo.first.label).to eq ["Salem"]

      g.nested_geo.first.label = ["Banana"]
      g.nested_geo.first.persist!
      expect(g.nested_geo.length).to eq 1
      expect(g.nested_geo.first.label).to eq ["Banana"]
    end
    it "should not create blank ones" do
      g = described_class.new(keyword: ['test'])
      g.nested_geo_attributes = [
          {
              :label => "",
              :point => "",
          }
      ]
      g.nested_ordered_title_attributes = nested_ordered_title_attributes
      expect(g.nested_geo.length).to eq 0
    end
  end
  it "should be able to create multiple nested geo points" do
    g = described_class.new(keyword: ['test'])
    g.nested_geo_attributes = [
        {
            "label" => "1"
        },
        {
            "label" => "2"
        }
    ]
    g.nested_ordered_title_attributes = nested_ordered_title_attributes
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
      g = described_class.new()
      g.nested_ordered_title_attributes = nested_ordered_title_attributes
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
      g = described_class.new()
      g.nested_ordered_title_attributes = nested_ordered_title_attributes
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
    it "should not persist item when only creator is blank" do
      g = described_class.new()
      g.nested_ordered_title_attributes = nested_ordered_title_attributes
      g.nested_ordered_creator_attributes = [
          {
              :index => "1",
              :creator => ""
          }
      ]
      expect(g.nested_ordered_creator.length).to eq 0
    end
    it "should persist item when only index is blank" do
      g = described_class.new()
      g.nested_ordered_title_attributes = nested_ordered_title_attributes
      g.nested_ordered_label_attributes = [
          {
              :index => "",
              :creator => "CreatorA"
          }
      ]
      expect(g.nested_ordered_creator.length).to eq 1
    end
    it "should work on already persisted items" do
      g = described_class.new()
      g.nested_ordered_title_attributes = nested_ordered_title_attributes
      g.nested_ordered_creator_attributes = attributes
      expect(g.nested_ordered_creator.first.creator).to eq ["CreatorA"]
    end
    it "should be able to edit" do
      g = described_class.new()
      g.nested_ordered_creator_attributes = attributes
      g.nested_ordered_title_attributes = nested_ordered_title_attributes
      expect(g.nested_ordered_creator.length).to eq 1
      expect(g.nested_ordered_creator.first.creator).to eq ["CreatorA"]

      g.nested_ordered_creator.first.creator = ["CreatorB"]
      g.nested_ordered_creator.first.persist!
      expect(g.nested_ordered_creator.length).to eq 1
      expect(g.nested_ordered_creator.first.creator).to eq ["CreatorB"]
    end
    it "should not create blank ones" do
      g = described_class.new(keyword: ['test'])
      g.nested_ordered_title_attributes = nested_ordered_title_attributes
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
    g = described_class.new()
    g.nested_ordered_title_attributes = nested_ordered_title_attributes
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

  describe "#nested_related_items_attributes" do
    let(:attributes) do
      [{
           :index => "0",
           :label => "LabelA",
           :related_url => "UrlA"
       }]
    end
    
    it "should be able to delete items" do
      g = described_class.new()
      g.nested_related_items_attributes = attributes
      g.nested_related_items_attributes = [
          {
              :id => g.nested_related_items.first.id,
              :_destroy => true
          },
          {
              :index => "1",
              :label => "LabelB",
              :related_url => "UrlB"
          }
      ]
      expect(g.nested_related_items.length).to eq 1
      expect(g.nested_related_items.first.label).to eq ["LabelB"]
    end
    it "should not persist items when all are blank" do
      g = described_class.new()
      g.nested_ordered_title_attributes = nested_ordered_title_attributes
      g.nested_related_items_attributes = [
          {
              :index => "",
              :label => "",
              :related_url => ""
          },
          {
              :index => "",
              :label => "",
              :related_url => ""
          }
      ]
      expect(g.nested_related_items.length).to eq 0
    end
    
    it "should work on already persisted items" do
      g = described_class.new()
      g.nested_related_items_attributes = attributes
      expect(g.nested_related_items.first.label).to eq ["LabelA"]
    end
    it "should be able to edit" do
      g = described_class.new()
      g.nested_related_items_attributes = attributes
      expect(g.nested_related_items.length).to eq 1
      expect(g.nested_related_items.first.label).to eq ["LabelA"]

      g.nested_related_items.first.label = ["LabelB"]
      g.nested_related_items.first.persist!
      expect(g.nested_related_items.length).to eq 1
      expect(g.nested_related_items.first.label).to eq ["LabelB"]
    end
    it "should not create blank ones" do
      g = described_class.new(keyword: ['test'])
      g.nested_related_items_attributes = [
          {
              :index => "",
              :label => "",
              :related_url => ""
          }
      ]
      expect(g.nested_related_items.length).to eq 0
    end
  end

  it "should be able to create multiple nested related items with order index" do
    g = described_class.new()
    g.nested_related_items_attributes = nested_related_items_attributes
    g.nested_related_items_attributes = [
        {
          "index" => "0",
          "related_url" => "ItemUrl1",
          "label" =>"Label1"
        },
        {
          "index" => "1",
          "related_url" => "ItemUrl2",
          "label" =>"Label2"
        }
    ]
    expect(g.nested_related_items.length).to eq 2
    expect(g.nested_related_items.map{|x| x.index.first}).to contain_exactly("0","1")
    expect(g.nested_related_items.map{|x| x.related_url.first}).to contain_exactly("ItemUrl1","ItemUrl2")
    expect(g.nested_related_items.map{|x| x.label.first}).to contain_exactly("Label1","Label2")
  end

  describe "#nested_ordered_title_attributes" do
    let(:attributes) do
      [{
        :index => "0",
        :title => "TitleA"
      }]
    end
    it "should be able to delete items" do
      g = described_class.new()
      g.nested_ordered_title_attributes = attributes
      g.nested_ordered_title_attributes = [
        {
          :id => g.nested_ordered_title.first.id,
          :_destroy => true
        },
        {
          :index => "1",
          :title => "TitleB"
        }
      ]
      expect(g.nested_ordered_title.length).to eq 1
      expect(g.nested_ordered_title.first.title).to eq ["TitleB"]
    end
    it "should not persist items when all are blank" do
      g = described_class.new()
      g.nested_ordered_title_attributes = [
        {
          :index => "",
          :title => ""
        },
        {
          :index => "",
          :title => ""
        }
      ]
      expect(g.nested_ordered_title.length).to eq 0
    end

    it "should not persist item when only title is blank" do
      g = described_class.new()
      g.nested_ordered_title_attributes = [
          {
              :index => "1",
              :title => ""
          }
      ]
      expect(g.nested_ordered_title.length).to eq 0
    end
    it "should persist item when only index is blank" do
      g = described_class.new()
      g.nested_ordered_title_attributes = [
          {
              :index => "",
              :title => "TitleA"
          }
      ]
      expect(g.nested_ordered_title.length).to eq 1
    end

    it "should work on already persisted items" do
      g = described_class.new()
      g.nested_ordered_title_attributes = attributes
      expect(g.nested_ordered_title.first.title).to eq ["TitleA"]
    end
    it "should be able to edit" do
      g = described_class.new()
      g.nested_ordered_title_attributes = attributes
      expect(g.nested_ordered_title.length).to eq 1
      expect(g.nested_ordered_title.first.title).to eq ["TitleA"]

      g.nested_ordered_title.first.title = ["TitleB"]
      g.nested_ordered_title.first.persist!
      expect(g.nested_ordered_title.length).to eq 1
      expect(g.nested_ordered_title.first.title).to eq ["TitleB"]
    end
    it "should not create blank ones" do
      g = described_class.new(keyword: ['test'])
      g.nested_ordered_title_attributes = [
        {
          :index => "",
          :title => "",
        }
      ]
      expect(g.nested_ordered_title.length).to eq 0
    end
  end

  it "should be able to create multiple nested ordered title" do
    g = described_class.new()
    g.nested_ordered_title_attributes = [
      {
        "index" => "0",
        "title" => "Title1"
      },
      {
        "index" => "1",
        "title" => "Title2"
      }
    ]
    expect(g.nested_ordered_title.length).to eq 2
    expect(g.nested_ordered_title.map{|x| x.index.first}).to contain_exactly("0","1")
    expect(g.nested_ordered_title.map{|x| x.title.first}).to contain_exactly("Title1","Title2")
  end

  describe "#nested_ordered_contributor_attributes" do
    let(:attributes) do
      [{
        :index => "0",
        :contributor => "ContributorA"
      }]
    end

    it "should be able to delete items" do
      g = described_class.new()
      g.nested_ordered_title_attributes = nested_ordered_title_attributes
      g.nested_ordered_contributor_attributes = attributes
      g.nested_ordered_contributor_attributes = [
        {
          :id => g.nested_ordered_contributor.first.id,
          :_destroy => true
        },
        {
          :index => "1",
          :contributor => "ContributorB"
        }
      ]
      expect(g.nested_ordered_contributor.length).to eq 1
      expect(g.nested_ordered_contributor.first.contributor).to eq ["ContributorB"]
    end
    it "should not persist items when all are blank" do
      g = described_class.new()
      g.nested_ordered_title_attributes = nested_ordered_title_attributes
      g.nested_ordered_contributor_attributes = [
        {
          :index => "",
          :contributor => ""
        },
        {
          :index => "",
          :contributor => ""
        }
      ]
      expect(g.nested_ordered_contributor.length).to eq 0
    end

    it "should not persist item when only contributor is blank" do
      g = described_class.new()
      g.nested_ordered_contributor_attributes = [
          {
              :index => "1",
              :contributor => ""
          }
      ]
      expect(g.nested_ordered_contributor.length).to eq 0
    end
    it "should persist item when only index is blank" do
      g = described_class.new()
      g.nested_ordered_contributor_attributes = [
          {
              :index => "",
              :contributor => "ContributorA"
          }
      ]
      expect(g.nested_ordered_contributor.length).to eq 1
    end

    it "should work on already persisted items" do
      g = described_class.new()
      g.nested_ordered_title_attributes = nested_ordered_title_attributes
      g.nested_ordered_contributor_attributes = attributes
      expect(g.nested_ordered_contributor.first.contributor).to eq ["ContributorA"]
    end
    it "should be able to edit" do
      g = described_class.new()
      g.nested_ordered_contributor_attributes = attributes
      g.nested_ordered_title_attributes = nested_ordered_title_attributes
      expect(g.nested_ordered_contributor.length).to eq 1
      expect(g.nested_ordered_contributor.first.contributor).to eq ["ContributorA"]

      g.nested_ordered_contributor.first.contributor = ["ContributorB"]
      g.nested_ordered_contributor.first.persist!
      expect(g.nested_ordered_contributor.length).to eq 1
      expect(g.nested_ordered_contributor.first.contributor).to eq ["ContributorB"]
    end
    it "should not create blank ones" do
      g = described_class.new(keyword: ['test'])
      g.nested_ordered_title_attributes = nested_ordered_title_attributes
      g.nested_ordered_contributor_attributes = [
        {
          :index => "",
          :contributor => "",
        }
      ]
      expect(g.nested_ordered_contributor.length).to eq 0
    end
  end

  describe "#nested_ordered_abstract_attributes" do
    let(:attributes) do
      [{
        :index => "0",
        :abstract => "AbstractA"
      }]
    end

    it "should be able to delete items" do
      g = described_class.new()
      g.nested_ordered_title_attributes = nested_ordered_title_attributes
      g.nested_ordered_abstract_attributes = attributes
      g.nested_ordered_abstract_attributes = [
        {
          :id => g.nested_ordered_abstract.first.id,
          :_destroy => true
        },
        {
          :index => "1",
          :abstract => "AbstractB"
        }
      ]
      expect(g.nested_ordered_abstract.length).to eq 1
      expect(g.nested_ordered_abstract.first.abstract).to eq ["AbstractB"]
    end
    it "should not persist items when all are blank" do
      g = described_class.new()
      g.nested_ordered_title_attributes = nested_ordered_title_attributes
      g.nested_ordered_abstract_attributes = [
        {
          :index => "",
          :abstract => ""
        },
        {
          :index => "",
          :abstract => ""
        }
      ]
      expect(g.nested_ordered_abstract.length).to eq 0
    end

    it "should not persist item when only abstract is blank" do
      g = described_class.new()
      g.nested_ordered_abstract_attributes = [
          {
              :index => "1",
              :abstract => ""
          }
      ]
      expect(g.nested_ordered_abstract.length).to eq 0
    end

    it "should persist item when only index is blank" do
      g = described_class.new()
      g.nested_ordered_abstract_attributes = [
          {
              :index => "",
              :abstract => "AbstractA"
          }
      ]
      expect(g.nested_ordered_abstract.length).to eq 1
    end

    it "should work on already persisted items" do
      g = described_class.new()
      g.nested_ordered_title_attributes = nested_ordered_title_attributes
      g.nested_ordered_abstract_attributes = attributes
      expect(g.nested_ordered_abstract.first.abstract).to eq ["AbstractA"]
    end
    it "should be able to edit" do
      g = described_class.new()
      g.nested_ordered_abstract_attributes = attributes
      g.nested_ordered_title_attributes = nested_ordered_title_attributes
      expect(g.nested_ordered_abstract.length).to eq 1
      expect(g.nested_ordered_abstract.first.abstract).to eq ["AbstractA"]

      g.nested_ordered_abstract.first.abstract = ["AbstractB"]
      g.nested_ordered_abstract.first.persist!
      expect(g.nested_ordered_abstract.length).to eq 1
      expect(g.nested_ordered_abstract.first.abstract).to eq ["AbstractB"]
    end
    it "should not create blank ones" do
      g = described_class.new(keyword: ['test'])
      g.nested_ordered_title_attributes = nested_ordered_title_attributes
      g.nested_ordered_abstract_attributes = [
        {
          :index => "",
          :abstract => "",
        }
      ]
      expect(g.nested_ordered_abstract.length).to eq 0
    end
  end


  describe "#attributes=" do
    it "accepts nested attributes" do
      g = described_class.new(keyword: ['test'])
      g.nested_ordered_title_attributes = nested_ordered_title_attributes
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
      g = described_class.new(keyword: ['test'])
      g.nested_ordered_title_attributes = nested_ordered_title_attributes
      expect(g.visibility).to eq 'open'
    end
  end
end
