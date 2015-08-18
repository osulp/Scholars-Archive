require 'rails_helper'

RSpec.describe GenericFile do
  it "should be able to persist" do
    expect{GenericFile.new.save}.not_to raise_error
  end
  describe "#nested_authors_attributes" do
    let(:attributes) do
      {
        "0" => {
          :name => "Bob",
          :orcid => "Test"
        }
      }

    end
    it "should be able to delete items" do
      g = described_class.new
      g.nested_authors_attributes = attributes
      g.save!(:validate => false)
      g.nested_authors_attributes = {
        "0" => {
          :id => g.nested_authors.first.id,
          :_destroy => true
        },
        "1" => {
          :name => "Banana"
        }
      }
      
      g.save!(:validate => false)
      g.reload

      expect(g.nested_authors.length).to eq 1
      expect(g.nested_authors.first.name).to eq ["Banana"]
    end
    it "should work on already persisted items" do
      g = described_class.new.tap{|x| x.save(:validate => false)}
      g.nested_authors_attributes = attributes

      g.save!(:validate => false)
      g.reload

      expect(g.nested_authors.first.name).to eq ["Bob"]
    end
    it "should be able to edit" do
      g = described_class.new
      g.nested_authors_attributes = attributes
      g.save!(:validate => false)
      g.nested_authors_attributes = {
        "0" => {
          :id => g.nested_authors.first.id,
          :name => "Banana"
        }
      }
      
      g.save!(:validate => false)
      g.reload

      expect(g.nested_authors.length).to eq 1
      expect(g.nested_authors.first.name).to eq ["Banana"]
    end
    it "should not create blank ones" do
      g = described_class.new
      g.nested_authors_attributes = {
        "0" => {
          :name => "",
          :orcid => ""
        }
      }
      expect(g.nested_authors.length).to eq 0
    end
  end
  it "should be able to create nested authors" do
    g = described_class.new
    g.nested_authors_attributes = [{:name => "Bob", :orcid => "Test"}]
    g.save!(:validate => false)

    g.reload

    expect(g.nested_authors.first.name).to eq ["Bob"]
    expect(g.nested_authors.first.orcid).to eq ["Test"]
  end
  it "should be able to create multiple nested authors" do
    g = described_class.new
    g.nested_authors_attributes = {
      "0" => {
        "name" => "1"
      },
      "1" => {
        "name" => "2"
      }
    }

    g.save!(:validate => false)
    g.reload

    expect(g.nested_authors.length).to eq 2
    expect(g.nested_authors.map{|x| x.name.first}).to contain_exactly("1","2")
  end
  describe "#attributes=" do
    it "accepts nested attributes" do
      g = described_class.new
      g.attributes = {
        :nested_authors_attributes => [
          {
            :name => "Bob",
            :orcid => "Test"
          }
        ]
      }

      g.save!(:validate => false)
      g.reload

      expect(g.nested_authors.first.name).to eq ["Bob"]
    end
  end
end
