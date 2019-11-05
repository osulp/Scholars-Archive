# frozen_string_literal: true

module Hyrax
  module Renderers
    # renders external link on show page
    class ExternalLinkAttributeRenderer < AttributeRenderer
      private

        def li_value(value)
          normalized_link = value.include?('http://') ? auto_link(value) : "http://#{auto_link(value)}".html_safe
          "<a href='#{normalized_link.html_safe}'>#{value}</a>&nbsp;&nbsp;<span class='glyphicon glyphicon-new-window'></span>".html_safe
        end
    end
  end
end
