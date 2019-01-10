# frozen_string_literal: true

module ScholarsArchive::Embargoes
  class EmbargoReleaser
    def self.expire_embargoes
      file_name = "#{Date.today}-embargo-release.log"
      logger = Logger.new(File.join(Rails.root, 'log', file_name))

      expired_embargoes = Hyrax::EmbargoService.assets_with_expired_embargoes
      expired_embargoes.each do |embargo|
        work = ActiveFedora::Base.find(embargo.solr_document[:id])
        logger.warn("Processing work id: #{work.id}")
        begin
          work.embargo_visibility!
          work.deactivate_embargo!
          work.embargo.save!
          work.save!(validate: false)
          if work.file_set?
            work.visibility = work.to_solr['visibility_after_embargo_ssim']
            work.save!(validate: false)
          elsif !work.file_set?
            work.copy_visibility_to_files
          end
        rescue => e
          logger.warn("Couldnt process #{work.id}")
          logger.warn([e.message]+e.backtrace).join("\n")
        end
      end
    end
  end
end
