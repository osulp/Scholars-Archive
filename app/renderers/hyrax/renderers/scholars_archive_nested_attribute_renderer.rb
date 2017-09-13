module Hyrax
  # Necessary include in Hyrax::Renderers module so that Hyrax::PresentsAttributes
  # is able to dynamically find it in #find_renderer_class
  module Renderers
    # This is used by PresentsAttributes to show nested fields
    #   e.g.: presenter.attribute_to_html(:nested_geo, render_as: :scholars_archive_nested, search_field: 'nested_geo_sim')
    class ScholarsArchiveNestedAttributeRenderer < Hyrax::Renderers::SearchAndExternalLinkAttributeRenderer
      private

      ##
      # Special treatment for nested attributes
      def li_value(value)
        if itemprop_option == 'url'
          itemprop_url_wrapper do
            links_to_search_field_and_external_uri(search_field, value)
          end
        elsif itemprop_option == 'geo'
          itemprop_geo_wrapper do
            link_to_sa_field(search_field, value)
          end
        else
          link_to_sa_field(search_field, value)
        end
      end

      def itemprop_option
        options.fetch(:itemprop_option)
      end

      def itemprop_geo_wrapper
        <<-HTML
          <span itemprop="geo" itemscope itemtype="http://schema.org/GeoCoordinates">
            <span itemprop="name">
              #{yield}
            </span>
          </span>
        HTML
      end

      def itemprop_url_wrapper
        <<-HTML
          <span itemprop="relatedLink" itemscope itemtype="http://schema.org/relatedLink">
            <span itemprop="url">
              #{yield}
            </span>
          </span>
        HTML
      end
    end
  end
end
