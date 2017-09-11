module ScholarsArchive
  module HasSolrLabels
    extend ActiveSupport::Concern

    included do
      def to_solr(solr_doc = {})
        super.tap do |doc|
          nested_geo.each do |geo|
            if geo.instance_of? NestedGeo
              if geo.point.present? && geo.type.blank?
                geo.point = geo.label.first+' (' + geo.point.first + ')'
                geo.type = :point.to_s
              end
              if geo.bbox.present? && geo.type.blank?
                geo.bbox = geo.label.first+' (' + geo.bbox.first + ')'
                geo.type = :bbox.to_s
              end
            end
          end
          labels = nested_geo.flat_map(&:point).select(&:present?).flatten.map {|i| i[0]}+nested_geo.flat_map(&:bbox).select(&:present?).flatten.map {|i| i[0]}
          doc[ActiveFedora.index_field_mapper.solr_name("nested_geo_label", :symbol)] = labels
          doc[ActiveFedora.index_field_mapper.solr_name("nested_geo_label", :stored_searchable)] = labels
          doc[ActiveFedora.index_field_mapper.solr_name("nested_related_items_label", :symbol)] = nested_related_items.map{|i| "#{i.label.first}$#{i.related_url.first}" }.select(&:present?)
          doc[ActiveFedora.index_field_mapper.solr_name("nested_related_items_label", :stored_searchable)] = nested_related_items.map{|i| "#{i.label.first}$#{i.related_url.first}" }.select(&:present?)
          doc[ActiveFedora.index_field_mapper.solr_name("rights_statement", :facetable)] = rights_statement.first
          doc[ActiveFedora.index_field_mapper.solr_name("license", :facetable)] = license.first
        end
      end
    end
  end
end
