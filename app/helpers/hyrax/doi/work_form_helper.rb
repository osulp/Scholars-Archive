# frozen_string_literal: true

module Hyrax
  module DOI
    # DOI plugin form helper to add DOI tab
    module WorkFormHelper
      def form_tabs_for(form:)
        if form.model_class.ancestors.include? Hyrax::DOI::DOIBehavior
          super.insert(1, 'doi')
        else
          super
        end
      end
    end
  end
end
