module ScholarsArchive
  module FilesController
    extend ActiveSupport::Autoload
    include Sufia::FilesController

  end
  module FilesControllerBehavior
    extend ActiveSupport::Concern
    include Sufia::FilesControllerBehavior

    protected
      def actor
        @actor ||= ScholarsArchive::GenericFile::Actor.new(@generic_file, current_user, attributes)
      end

      def attributes
        attributes = params.dup
      end

      def process_file(file)
        Batch.find_or_create(params[:batch_id])

        update_metadata_from_upload_screen

        actor.create_metadata(params[:batch_id])

        if actor.create_content(file, file.original_filename, file_path, file.content_type, params[:collection])
          respond_to do |format|
            format.html {
              render 'jq_upload', formats: 'json', content_type: 'text/html'
            }
            format.json {
              render 'jq_upload'
            }
          end
        else
          msg = @generic_file.errors.full_messages.join(', ')
          flash[:error] = msg
          json_error "Error creating generic file: #{msg}"
        end
      end
  end
end
