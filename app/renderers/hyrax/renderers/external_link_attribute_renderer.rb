# frozen_string_literal: true

module Hyrax
  module Renderers
    class ExternalLinkAttributeRenderer < AttributeRenderer
      private

        def li_value(value)
          auto_link(value) do |link|
            "#{link}&nbsp;&nbsp;<span class='glyphicon glyphicon-new-window'></span>"
          end
        end
    end
  end
end
