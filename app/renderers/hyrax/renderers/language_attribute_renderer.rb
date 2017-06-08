module Hyrax
  # Necessary include in Hyrax::Renderers module so that Hyrax::PresentsAttributes
  # is able to dynamically find it in #find_renderer_class
  module Renderers
    # This is used by PresentsAttributes to show languages
    #   e.g.: presenter.attribute_to_html(:language, render_as: :language)a
    class LanguageAttributeRenderer < AttributeRenderer
      private

        ##
        # Special treatment for language.  A URL from the Hyrax gem's config/hyrax.rb is stored in the descMetadata of the
        # curation_concern.  If that URL is valid in form, then it is used as a link.  If it is not valid, it is used as plain text.
        def attribute_value_to_html(value)
          begin
            parsed_uri = URI.parse(value)
          rescue
            nil
          end
          if parsed_uri.nil?
            ERB::Util.h(value)
          else
            %(<a href=#{ERB::Util.h(value)} target="_blank">#{ScholarsArchive::LanguageService.new.label(value)}</a>)
          end
        end
    end
  end
end
