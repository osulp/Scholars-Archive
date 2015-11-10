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
        @actor ||= ::GenericFiles::Actor.new(@generic_file, current_user, attributes)
      end

      def attributes
        attributes = params.dup
      end

      def process_file(file)
        Batch.find_or_create(params[:batch_id])

        update_metadata_from_upload_screen
        if params[:resource_type].present?
          actor.create_metadata_with_resource_type(params[:batch_id], params[:resource_type])
        else
          actor.create_metadata(params[:batch_id])
        end

        if actor.create_content(file, file.original_filename, file_path, file.content_type)
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
