module ScholarsArchive
  module GenericFile
    class Actor < Sufia::GenericFile::Actor
      include ScholarsArchive::ManagesEmbargoActor

      attr_reader :attributes, :generic_file, :user

      def initialize(generic_file, user, input_attributes)
        super(generic_file, user)
        @attributes = input_attributes

      end

      def update_visibility(visibility)
        interpret_visibility
      end

      def update_metadata(attributes, visibility)
        date_created = attributes[:date_created]
        generic_file.year_created  = date_created[/(\d\d\d\d)/,0] unless date_created.nil? || date_created.blank?
        if attributes['hasCollectionId'] && !attributes['hasCollectionId'].empty?
          attributes['hasCollectionId'].each do |id| 
            collection = Collection.find(id)
            collection.member_ids << [generic_file.id] 
            collection.save
          end
        end
        super
      end

      def create_metadata_with_resource_type(batch_id, resource_type)
        if resource_type
          generic_file.resource_type = [resource_type]
        else
          ActiveFedora::Base.logger.warn "unable to find the resource type it sets to"
        end

        create_metadata(batch_id)
      end


    end
  end
end
