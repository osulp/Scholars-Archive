require 'rails_helper'

RSpec.describe Enricher do  
  let(:file) do
    GenericFile.new(id) { |file| file.apply_depositor_metadata('zhanghu') }
  end
  let(:id) do
    id = 'id001'
  end  

  before do
    file.save!
    file.subject = [uri]
  end
  
  let(:uri) { resource.rdf_subject }
  let(:resource) do
    r = TriplePoweredResource.new("http://localhost:40/1")
    r.preflabel = "Test"
    r.persist!
    r
  end

  describe "#atomic update" do
    before do
      file.save!
    end   

    it "should return enriched solr field" do
      enricher = Enricher.new(id)
      enricher.enrich!
      expect(ActiveFedora::SolrService.query("id:#{RSolr.solr_escape(id)}").first["subject_preferred_label_ssim"]).to eq ["Test"]
    end
  end

  it "should be able to persist" do
    expect{GenericFile.new.save}.not_to raise_error
  end

end
