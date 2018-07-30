module ScholarsArchive::Embargoes
  class EmbargoReleaser
    def self.expire_embargoes
      expired_embargoes = Hyrax::EmbargoService.assets_with_expired_embargoes
      expired_embargoes.each do |embargo|
        work = ActiveFedora::Base.find(embargo.solr_document[:id])
        expired = true

        #attempt to expire embargo
        begin
          Hyrax::Actors::EmbargoActor.new(work).destroy
        rescue => e
          file_name = Date.today.to_s + "-embargo-debug.log"
          logger = Logger.new(File.join(Rails.root, 'log', file_name))
          logger.warning("Couldnt destroy embargo for #{work.id}")
          logger.warning ([e.message]+e.backtrace).join("\n")
          expired = false
        end

        if work.file_set? && expired
          work.visibility = work.to_solr["visibility_after_embargo_ssim"]

          #Attempt to save the file_set
          begin
            work.save!
          rescue => e
            file_name = Date.today.to_s + "-embargo-file_set-debug.log"
            logger = Logger.new(File.join(Rails.root, 'log', file_name))
            logger.warning("Couldnt update fileset #{work.id}")
            logger.warning ([e.message]+e.backtrace).join("\n")
          end

        elsif !work.file_set? && expired

          #Attempt to copy visibility
          begin
            work.copy_visibility_to_files
          rescue => e
            file_name = Date.today.to_s + "-embargo-copy_vis-debug.log"
            logger = Logger.new(File.join(Rails.root, 'log', file_name))
            logger.warning("Couldnt copy visibility for #{work.id}")
            logger.warning ([e.message]+e.backtrace).join("\n")
          end

        end
      end
    end
  end
end
