module ScholarsArchive::Embargoes
  class EmbargoReleaser
    extend Hyrax::EmbargoHelper
    
    def self.expire_embargoes
      expired_embargoes = self.find_all_expired_embargoes
      expired_embargoes.each do |embargo|
        work = ActiveFedora::Base.find(embargo.solr_document[:id])
        Hyrax::Actors::EmbargoActor.new(work).destroy
      end
      puts "Expired #{expired_embargoes.length} embargoes"
    end

    private

    def self.find_all_expired_embargoes
      assets_with_expired_embargoes
    end
  end
end
