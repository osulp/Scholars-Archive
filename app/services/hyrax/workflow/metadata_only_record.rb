# frozen_string_literal: true

# add method to make files private and change the owner to the admin group
module Hyrax
  module Workflow
    # Sets the work and filesets to private
    module MetadataOnlyRecord
      def self.call(user:, target:, **)
        target.file_sets.each do |file_set|
          file_set.destroy
        end
      end
    end
  end
end
