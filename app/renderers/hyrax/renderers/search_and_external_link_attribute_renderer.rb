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

      def search_type
        options.fetch(:search_type) if options.key?(:search_type)
      end

      def links_to_faceted_search_field(field, query)
        links = []
        if query.include?("$")
          label = query.split("$").first
          links << link_to(label, facet_search_path_for(query)) unless label.blank?
        end
        links.join('')
      end

      def links_to_search_field_and_external_uri(field, query)
        links = []
        unless query.include? '=>nil'
          if hash?(query)
            query_hash = JSON.parse(query.to_s.gsub('=>', ':'))
            label = query_hash['label']
            uri = query_hash['uri']
            index = query_hash['index']
          elsif query.include?("$")
            label = query.split("$").first
            uri = query.split("$").second
          else
            label = query
            uri = case field
              when 'rights_statement_label' then maybe_rights_statement_uri(query)
              when 'license_label' then maybe_license_uri(query)
              else maybe_uri(query)
            end
          end

          if search_type == 'faceted_and_external'
            query_item = "#{label}$#{uri}$#{index}"
            links << link_to(label, facet_search_path_for(query_item)) unless label.blank?
          else
            links << link_to(label, search_path_for(label)) unless label.blank?
          end

          links << link_to('<span class="glyphicon glyphicon-new-window"></span>'.html_safe, uri, 'aria-label' => "Open link in new window", class: 'btn', target: '_blank') unless uri.blank?
        end

        links.join('')
      end

      def search_path_for(s)
        Rails.application.class.routes.url_helpers.search_catalog_path(search_field: search_field, q: ERB::Util.h(s))
      end

      def facet_search_path_for(value)
        Rails.application.routes.url_helpers.search_catalog_path(:"f[#{symbol_field}][]" => value, locale: I18n.locale)
      end

      def symbol_field
        ERB::Util.h(Solrizer.solr_name(search_field, :symbol, type: :string))
      end

      def hash?(s)
        s.include? '=>'
      end

      def maybe_uri(s)
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
