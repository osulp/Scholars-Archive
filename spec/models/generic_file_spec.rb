require 'rails_helper'

RSpec.describe GenericFile do
  subject { described_class.new(property) }
  let(:property) { SolrProperty.new("subject_ssim", value) }
  let(:value) { "http://localhost:40/1" }
  describe "#properties" do
    context "when there's subjects" do
      it "should return a nice property" do
        build_resource(uri: value, label: "LC Subject").tap do |r|
          r << [r.rdf_subject, RDF::SKOS.altLabel, "Alternative"]
          r << [r.rdf_subject, RDF::SKOS.altLabel, "More labels"]
        end.persist!

        property = subject.properties.first
        expect(property.values).to eq ["Alternative", "More labels"]
        expect(property.key).to eq "subject_alternative_label"
        expect(property.solr_identifier).to eq "ssim"
      end
    end
    context "when there's no label" do
      it "should return an empty array property" do
        expect(subject.properties.first.values).to eq []
      end
    end
  end

  it "should be able to persist" do
    expect{GenericFile.new.save}.not_to raise_error
  end

  def build_resource(properties = {})
    return TriplePoweredResource.new(properties)
  end
end
