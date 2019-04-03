# frozen_string_literal: true

module Hyrax
  module Renderers
    # renders search and external link on show page
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
        unless query.include? '=>nil'
          if hash?(query)
            query_hash = JSON.parse(query.to_s.gsub('=>', ':'))
            label = query_hash['label']
            uri = query_hash['uri']
          elsif query.include?('$')
            label = query.split('$').first
            uri = query.split('$').second
          else
            label = query
            uri = case field
              when 'rights_statement_label' then maybe_rights_statement_uri(query)
              when 'license_label' then maybe_license_uri(query)
              else maybe_uri(query)
            end
          end
          links << link_to(label, search_path_for(label)) unless label.blank?
          links << link_to('<span class="glyphicon glyphicon-new-window"></span>'.html_safe, uri, 'aria-label' => 'Open link in new window', class: 'btn', target: '_blank') unless uri.blank?
        end

        links.join('')
      end

      def search_path_for(s)
        Rails.application.class.routes.url_helpers.search_catalog_path(search_field: search_field, q: ERB::Util.h(s))
      end

      def hash?(s)
        s.include? '=>'
      end

      def maybe_uri(s)
        s = Addressable::URI.escape(s) if %w[http https].any? { |p| s.include? p }
        URI.extract(s, %w[http https]).first || ''
      end

      def maybe_license_uri(term)
        extract_value_from_yaml(YAML.load_file(File.join(Rails.root, 'config', 'authorities', 'licenses.yml')), term)
      end

      def maybe_rights_statement_uri(term)
        extract_value_from_yaml(YAML.load_file(File.join(Rails.root, 'config', 'authorities', 'rights_statements.yml')), term)
      end

      def extract_value_from_yaml(yaml, term)
        value = yaml['terms'].find { |l| l['term'].casecmp(term).zero? }
        return '' if value.nil?

        value['id']
      end
    end
  end
end
