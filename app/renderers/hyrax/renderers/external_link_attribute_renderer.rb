# frozen_string_literal: true

module Hyrax
  module Renderers
    # renders external link on show page
    class ExternalLinkAttributeRenderer < AttributeRenderer
      private

        def li_value(value)
          normalized_link = value.include?('http://') ? value : "http://#{value}"
          "<a href='#{normalized_link}'>#{value}</a>&nbsp;&nbsp;<span class='glyphicon glyphicon-new-window'></span>"
        end
    end
  end
end
