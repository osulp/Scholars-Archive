require 'rails_helper'

RSpec.describe GenericFile do  
  let(:file) do
    GenericFile.new(id)
  end
  let(:id) { 'someid' }
  subject{ file }
  before do
    subject.subject = [uri]
  end
  let(:uri) { resource.rdf_subject }
  let(:resource) do
    r = TriplePoweredResource.new("http://localhost:40/1")
    r.preflabel = "Test"
    r.persist!
    r
  end

  describe "#atomic update" do
    let(:connection) { ActiveFedora.solr.conn }
    let(:solr_document) do
      s = ActiveFedora::SolrService.query("id:#{RSolr.solr_escape(id)}").first
    end
    let(:enriched_solr_document) do
      es = EnrichedSolrDocument.new(solr_document).to_solr
    end
    let(:solr_json) do
      sj = enriched_solr_document.to_json
    end
    before do
      connection.update(
        :params => { softCommit: true },
        :data => solr_json,
        :headers => { 'Content-Type' => 'application/json' }
      )
    end
      
    it "should return enriched solr field" do
      expect(ActiveFedora::SolrService.query("id:#{id}").first["lcsubject_preferred_label_ssim"]).to eq ["Test"]
    end
  end
end
