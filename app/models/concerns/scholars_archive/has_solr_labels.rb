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
          point_labels = nested_geo.flat_map{ |i| (i.instance_of? NestedGeo) ? i.point : "" }.select(&:present?).flatten.map {|i| i[0]}
          bbox_labels = nested_geo.flat_map{ |i| (i.instance_of? NestedGeo) ? i.bbox : "" }.select(&:present?).flatten.map {|i| i[0]}
          labels = point_labels + bbox_labels
          related_items_labels = nested_related_items.map{|i| (i.instance_of? NestedRelatedItems) ? "#{i.label.first}$#{i.related_url.first}" : i }.select(&:present?)
          ordered_creator_labels = nested_ordered_creator.map{|i| (i.instance_of? NestedOrderedCreator) ? "#{i.creator.first}$#{i.index.first}" : i }.select(&:present?)
          doc[ActiveFedora.index_field_mapper.solr_name("nested_geo_label", :symbol)] = labels
          doc[ActiveFedora.index_field_mapper.solr_name("nested_geo_label", :stored_searchable)] = labels
          doc[ActiveFedora.index_field_mapper.solr_name("nested_related_items_label", :symbol)] = related_items_labels
          doc[ActiveFedora.index_field_mapper.solr_name("nested_related_items_label", :stored_searchable)] = related_items_labels
          doc[ActiveFedora.index_field_mapper.solr_name("nested_ordered_creator_label", :symbol)] = ordered_creator_labels
          doc[ActiveFedora.index_field_mapper.solr_name("nested_ordered_creator_label", :stored_searchable)] = ordered_creator_labels
          doc[ActiveFedora.index_field_mapper.solr_name("rights_statement", :facetable)] = rights_statement.first
          doc[ActiveFedora.index_field_mapper.solr_name("license", :facetable)] = license.first
        end
      end
    end
  end
end
