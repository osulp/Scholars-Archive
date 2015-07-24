require 'rails_helper'
require 'enriched_solr_document'

RSpec.describe EnrichedSolrDocument do
  subject { described_class.new(solr_document) }
  before do
    ScholarsArchive.marmotta.delete_all
  end

  describe "#to_solr" do
    let(:document_result) { subject.to_solr }
    let(:solr_document) { {"id" => "1", "subject_ssim" => [uri.to_s]} }
    let(:uri) { "http://localhost:41/1" }
    it "should be a good solr document to atomic update" do
      build_resource(uri: uri, label: "Test")

      expect(document_result).to eq (
        {
          "id" => "1",
          "subject_preferred_label_ssim" => {"set" => ["Test"]}
        }
      )
    end
  end
  describe "#update_document" do
    let(:document_result) { subject.update_document }
    context "when there are no URIs" do
      let(:solr_document) { {"subject_ssim" => ["test"] } }
      it "should not be anything" do
        expect(document_result).to eq ( {} )
      end
    end
    context "when there are label-less URIs" do
      let(:solr_document) { {"subject_ssim" => [uri.to_s]} }
      let(:uri) { "http://localhost:41/1" }
      it "should return an empty document" do
        build_resource(uri: uri, label: nil)

        expect(document_result).to eq ( {} )
      end
    end
    context "when there are alternative labels" do
      let(:solr_document) { {"subject_ssim" => [uri.to_s]} }
      let(:uri) { "http://localhost:41/1" }
      it "should add them" do
        build_resource(uri: uri, label: "Test").tap do |r|
          r << [r.rdf_subject, RDF::SKOS.altLabel, "Another Test"]
        end.persist!

        expect(document_result).to eq (
          {
            "subject_preferred_label_ssim" => ["Test"],
            "subject_alternative_label_ssim" => ["Another Test"]
          }
        )
      end
    end
    context "when there are fields with no URIs" do
      let(:solr_document) { {"id" => "test", "subject_ssim" => ["test", uri.to_s]} }
      let(:uri) { "http://localhost:41/1" }
      it "should only deal with URI fields" do
        build_resource(uri: uri, label: "Test")

        expect(document_result).to eq (
          {
            "subject_preferred_label_ssim" => ["Test"]
          }
        )
      end
    end
    context "when there are labelled URIs" do
      let(:solr_document) { {"subject_ssim" => [uri.to_s, uri.to_s+"2"]} }
      let(:uri) { "http://localhost:41/1" }
      it "should return the label" do
        build_resource(uri: uri, label: "Test")
        build_resource(uri: uri+"2", label: "Test2")

        expect(document_result).to eq (
          {
            "subject_preferred_label_ssim" => ["Test", "Test2"]
          }
        )
      end
    end
    context "when there are labelled URIs with the same label" do
      let(:solr_document) { {"subject_ssim" => [uri.to_s, uri.to_s+"2"]} }
      let(:uri) { "http://localhost:41/1" }
      it "should de-duplicate" do
        build_resource(uri: uri, label: "Test")
        build_resource(uri: uri+"2", label: "Test")

        expect(document_result).to eq (
          {
            "subject_preferred_label_ssim" => ["Test"]
          }
        )
      end
    end
  end
end

