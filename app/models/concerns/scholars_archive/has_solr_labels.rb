module ScholarsArchive
  module HasSolrLabels
    extend ActiveSupport::Concern

    included do
      def to_solr(solr_doc = {})
        super.tap do |doc|
          build_nested_geo(nested_geo)

          point_labels = map_geo_to_labels(nested_geo, ActiveArchive::Geological, :point)
          bbox_labels = map_geo_to_labels(nested_geo, ActiveArchive::Geological, :bbox)
          labels = point_labels + bbox_labels

          #To add more nested objects, Add another line here
          related_items_labels = map_object_to_labels(nested_related_itmes, ActiveArchive::RelatedItems, :label, :related_url)
          ordered_creator_labels = map_object_to_labels(nested_ordered_creator, ActiveArchive::Creator, :creator, :index)
          ordered_title_labels = map_object_to_labels(nested_ordered_creator, ActiveArchive::Title, :title, :index)

          # Add the label and the data from the previous line here.
          labels = [{label: "nested_geo_label", data: labels }, 
                    {label: "nested_related_items_label", data: related_items_labels}, 
                    {label: "nested_ordered_creator_label", data: ordered_creator_labels},
                    {label: "nested_ordered_title_label", data: ordered_title_labels]]

          labels.each do |label_set|  
            doc[ActiveFedora.index_field_mapper.solr_name(label_set[:label], :symbol)] = label_set[:data]
            doc[ActiveFedora.index_field_mapper.solr_name(label_set[:label], :stored_searchable)] = label_set[:data] 
          end

          doc[ActiveFedora.index_field_mapper.solr_name("rights_statement", :facetable)] = rights_statement.first
          doc[ActiveFedora.index_field_mapper.solr_name("license", :facetable)] = license.first
        end
      end

      def map_object_to_labels(object, model_name, label_method, identifier_method)
        object.map{ |i| (i.instance_of? model_name) ? "#{i.call(label_method).first}$#{i.call(identifier_method).first}" : i }.select(&:present?)
      end

      def map_geo_to_labels(object, model_name, label_method)
        object.flat_map{ |i| (i.instance_of? model_name) ? i.call(label_method) : "" }.select(&:present?).flatten.map {|i| i[0]}
      end

      def build_nested_geo(nested_geo)
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
      end
    end
  end
end
