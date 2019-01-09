# frozen_string_literal: true

module ScholarsArchive
  # my shares behavior
  module MySharesBehavior
    extend ActiveSupport::Concern

    included do
      # We are adding custom_redirect here to prevent a template-not-found error for dashboard/shares path for now
      # A related issue has been reported here https://github.com/samvera/hyrax/issues/2767
      # TODO: Once hyrax/issues/2767 is resolved, remove custom_redirect and ScholarsArchive::MySharesBehavior as well if not needed
      def custom_redirect
        redirect_to hyrax.my_works_path and return
      end
    end
  end
end
