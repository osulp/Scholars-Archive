require 'rails_helper'

RSpec.describe GenericFile do  
  let(:file) do
    GenericFile.new(id: 'oneid') { |file| file.apply_depositor_metadata('terrellt') }
  end
  
  before do
    file.save!
    subject { file }
    subject.subject = [uri]
  end
  
  let(:uri) { resource.rdf_subject }
  let(:resource) do
    r = TriplePoweredResource.new("http://localhost:40/1")
    r.preflabel = "Test"
    r.persist!
    r
  end

  let(:connection) { ActiveFedora.solr.conn }
  let(:solr_document) do
    s = ActiveFedora::SolrService.query("id:#{RSolr.solr_escape('oneid')}").first
  end
  let(:enriched_solr_document) do
    es = EnrichedSolrDocument.new(solr_document).to_solr
  end
  let(:solr_json) do
    sj = enriched_solr_document.to_json
  end
  
  describe "#atomic update" do
    before do
      connection.update(
        :params => { softCommit: true },
        :data => solr_json,
        :headers => { 'Content-Type' => 'application/json' }
      )
    end
      
    it "should return enriched solr field" do
      expect(ActiveFedora::SolrService.query("id:#{'oneid'}").first["subject_preferred_label_ssim"]).to eq ["Test"]
    end
  end
end
