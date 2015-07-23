require 'rails_helper'
require 'language_selector'

RSpec.describe LanguageSelector do
  subject { described_class.new(literals) }
  
  let(:literals) { [literal, literal_2] }
  let(:literal) { RDF::Literal.new("Test", :language => :fr) }
  let(:literal_2) { RDF::Literal.new("Test", :language => :en) }

  describe "#labels" do
    it "should return the english labels" do
      expect(subject.labels).to eq [literal_2]
    end
    context "when there are only non-english labels" do
      let(:literal_2) { RDF::Literal.new("Test", :language => :de) }
      it "should return all labels" do
        expect(subject.labels).to eq literals
      end
    end
  end
end

RSpec.describe LanguageSelector::LabelFinderFactory do
  subject { described_class.new(finder_factory) }
  let(:finder_factory) { build_finder_factory }
  let(:resource) { double("resource") }
  describe "#new" do
    it "should create a LabelFinder" do
      expect(subject.new(resource)).to be_kind_of LanguageSelector::LabelFinder
      expect(finder_factory).to have_received(:new).with(resource)
    end
  end

  def build_finder_factory
    f = double("Label Finder Factory")
    allow(f).to receive(:new).and_return(build_finder)
    f
  end

  def build_finder
    double("Label Finder")
  end
end

RSpec.describe LanguageSelector::LabelFinder do
  subject { described_class.new(base_finder) }
  let(:base_finder) { build_finder }
  let(:labels) { [RDF::Literal.new("Test", :language => :en), RDF::Literal.new("Test2", :language => :fr)] }

  describe "#labels" do
    it "should return english language" do
      expect(subject.labels).to eq [RDF::Literal.new("Test", :language => :en)]
    end
  end

  def build_finder
    b = double("Label Finder")
    allow(b).to receive(:labels).and_return(labels)
    b
  end
end
