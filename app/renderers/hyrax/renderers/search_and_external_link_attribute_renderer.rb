module Hyrax
  module Renderers
    class SearchAndExternalLinkAttributeRenderer < AttributeRenderer
      include ApplicationHelper
      private

      def li_value(value)
        links_to_search_field_and_external_uri(search_field, value)
      end

      def search_field
        options.fetch(:search_field, field)
      end

      def links_to_search_field_and_external_uri(field, query)
        links = []
        query_hash = JSON.parse(query.to_s.gsub('=>', ':'))
        search_path = Rails.application.class.routes.url_helpers.search_catalog_path(
            search_field: search_field, q: ERB::Util.h(query_hash['label'])
        )
        links << link_to(query_hash['label'], search_path) if query_hash['label'].present?
        links << link_to('<span class="glyphicon glyphicon-new-window"></span>'.html_safe, query_hash['uri'], 'aria-label' => "Open link in new window", class: 'btn btn-defaul') if query_hash['uri'].present?
        links.join('')
      end
    end
  end
end
