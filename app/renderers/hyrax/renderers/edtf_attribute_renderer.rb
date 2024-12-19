# frozen_string_literal: true

module Hyrax
  # Necessary include in Hyrax::Renderers module so that Hyrax::PresentsAttributes
  # is able to dynamically find it in #find_renderer_class
  module Renderers
    # This is used by PresentsAttributes to show special dates
    #   e.g.: presenter.attribute_to_html(:date_created, render_as: :edtf, search_field: 'date_created_sim')
    class EdtfAttributeRenderer < AttributeRenderer
      include ApplicationHelper

      private

      ##
      # Special treatment for special dates (edtf)
      def attribute_value_to_html(value)
        date = Date.edtf(value)
        output = if date.present?
                   date.edtf
                 else
                   value
                 end

        link_to_sa_field(search_field, output)
      end

      def search_field
        options.fetch(:search_field, field)
      end
    end
  end
end
