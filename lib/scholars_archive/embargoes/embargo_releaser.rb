module ScholarsArchive::Embargoes
  class EmbargoReleaser
    def self.expire_embargoes
      expired_embargoes = Hyrax::EmbargoService.assets_with_expired_embargoes
      expired_embargoes.each do |embargo|
        work = ActiveFedora::Base.find(embargo.solr_document[:id])
        puts "Expired embargo for #{embargo.solr_document[:id]}"
        work.embargo_visibility!
        work.deactivate_embargo!
        work.embargo.save!
        # Having to skip validation because some migrated works still have broken/invalid metadata that won't necessarily
        # always pass standard validation.
        work.save!(validate: false)
      end
      puts "Expired #{expired_embargoes.length} embargoes"
    end
  end
end
