# add method to make files private and change the owner to the admin group
module Hyrax
  module Workflow
    module MetadataOnlyRecord
      def self.call(user:, target:, **)
        target.file_sets.each do |file_set|
          Hyrax::Actors::FileSetActor.new(file_set, user)
              .update_metadata(visibility: Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE)
        end
      end
    end
  end
end