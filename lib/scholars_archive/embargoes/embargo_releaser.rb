# frozen_string_literal: true

module ScholarsArchive::Embargoes
  # Embargo Releaser
  class EmbargoReleaser
    def self.expire_embargoes
      file_name = "#{Date.today}-embargo-release.log"
      logger = Logger.new(File.join(Rails.root, 'log', file_name))

      expired_embargoes = Hyrax::EmbargoService.assets_with_expired_embargoes
      expired_embargoes.each do |embargo|
        unless ActiveFedora::Base.exists?(embargo.solr_document[:id])
          logger.warn("Skipping work #{embargo.solr_document[:id]} since it doesn't exist. Couldnt process embargo release for this work.")
          next
        end

        work = ActiveFedora::Base.find(embargo.solr_document[:id])

        next if work.under_embargo?

        logger.warn("Processing work id: #{work.id}")

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
      rescue StandardError => e
        logger.error("Couldnt process #{work.id}")
        logger.error([e.message]+e.backtrace).join("\n")
        return nil
      end
    end
  end
end
