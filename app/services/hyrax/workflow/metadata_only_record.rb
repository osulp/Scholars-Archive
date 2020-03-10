# frozen_string_literal: true

# add method to make files private and change the owner to the admin group
module Hyrax
  module Workflow
    # Sets the work and filesets to private
    module MetadataOnlyRecord
      # rubocop:disable Lint/UnusedMethodArgument
      def self.call(user: _user, target:, **)
        target.file_sets.each(&:destroy)
        target.thumbnail_id = ''
      end
      # rubocop:enable Lint/UnusedMethodArgument
    end
  end
end
