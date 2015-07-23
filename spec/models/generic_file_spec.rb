require 'rails_helper'

RSpec.describe GenericFile do  
  let(:file) do
    #GenericFile.new(id: 'oneid_2') { |file| file.apply_depositor_metadata('terrellt') }
    GenericFile.new(id) { |file| file.apply_depositor_metadata('terrellt') }
  end
  let(:id) do
    id = 'id006'
  end  

  before do
    file.save!
    subject { file }
    subject.subject = [uri]
    subject.save!
  end
  
  let(:uri) { resource.rdf_subject }
  let(:resource) do
    r = TriplePoweredResource.new("http://localhost:40/1")
    r.preflabel = "Test2"
    r.persist!
    r
  end

  let(:connection) { ActiveFedora.solr.conn }
  let(:solr_document) do
    ActiveFedora::SolrService.query("id:#{RSolr.solr_escape(id)}").first
  end
  let(:enriched_solr_document) do
    EnrichedSolrDocument.new(solr_document).to_solr
  end
  let(:solr_json) do
    # array is required for to_json 
    [enriched_solr_document].to_json
  end
  
  describe "#atomic update" do
    before do
    file.save!
    binding.pry
      connection.update(
        :params => { softCommit: true },
        :data => solr_json,
        :headers => { 'Content-Type' => 'application/json' }
      )
    end
      
    it "should return enriched solr field" do
      expect(ActiveFedora::SolrService.query("id:#{RSolr.solr_escape(id)}").first["subject_preferred_label_ssim"]).to eq ["Test"]
    end
  end
end
