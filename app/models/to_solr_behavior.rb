module ToSolrBehavior
  extend ActiveSupport::Concern

  included do
    def to_solr(solr_doc = {})
      super.tap do |doc|
        nested_geo.each do |geo|
          if geo.point.present?
            geo.type = :point.to_s
            geo.point = geo.label.first+' (' + geo.point.first + ')'
          end
          if geo.bbox.present?
            geo.type = :bbox.to_s
            geo.bbox = geo.label.first+' (' + geo.bbox.first + ')'
          end
        end
        labels = nested_geo.flat_map(&:point).select(&:present?).flatten.map {|i| i[0]}+nested_geo.flat_map(&:bbox).select(&:present?).flatten.map {|i| i[0]}
        doc[ActiveFedora.index_field_mapper.solr_name("nested_geo_label", :symbol)] = labels
        doc[ActiveFedora.index_field_mapper.solr_name("nested_geo_label", :stored_searchable)] = labels
      end
    end
  end
end
