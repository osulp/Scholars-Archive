# frozen_string_literal: true

module Hyrax
  # Necessary include in Hyrax::Renderers module so that Hyrax::PresentsAttributes
  # is able to dynamically find it in #find_renderer_class
  module Renderers
    # This is used by PresentsAttributes to preformatted text (with newlines)
    #   e.g.: presenter.attribute_to_html(:abstract, render_as: :preformatted)
    class PreformattedAttributeRenderer < AttributeRenderer
      private

      ##
      # Special treatment preformatted text

      def attribute_value_to_html(value)
        if microdata_value_attributes(field).present?
          "<dd class='preformatted' #{html_attributes(microdata_value_attributes(field))}>#{li_value(value)}</dd>"
        else
          "<dd class='preformatted'>#{li_value(value)}</dd>"
        end
      end
    end
  end
end
