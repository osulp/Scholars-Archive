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
          related_items_labels = nested_related_items.map{|i| (i.instance_of? NestedRelatedItems) ? "#{i.label.first}$#{i.related_url.first}$#{i.index.first}" : i }.select(&:present?)
          ordered_creator_labels = nested_ordered_creator.map{|i| (i.instance_of? NestedOrderedCreator) ? "#{i.creator.first}$#{i.index.first}" : i }.select(&:present?)
          ordered_title_labels = nested_ordered_title.map{|i| (i.instance_of? NestedOrderedTitle) ? "#{i.title.first}$#{i.index.first}" : i }.select(&:present?)
          ordered_alt_title_labels = nested_ordered_alt_title.map{|i| (i.instance_of? NestedOrderedAltTitle) ? "#{i.alt_title.first}$#{i.index.first}" : i }.select(&:present?)
          ordered_abstract_labels = nested_ordered_abstract.map{|i| (i.instance_of? NestedOrderedAbstract) ? "#{i.abstract.first}$#{i.index.first}" : i }.select(&:present?)
          ordered_contributor_labels = nested_ordered_contributor.map{|i| (i.instance_of? NestedOrderedContributor) ? "#{i.contributor.first}$#{i.index.first}" : i }.select(&:present?)
          ordered_description_labels = nested_ordered_description.map{|i| (i.instance_of? NestedOrderedDescription) ? "#{i.description.first}$#{i.index.first}" : i }.select(&:present?)
          ordered_editor_labels = nested_ordered_editor.map{|i| (i.instance_of? NestedOrderedEditor) ? "#{i.editor.first}$#{i.index.first}" : i }.select(&:present?)
          ordered_tableofcontents_labels = nested_ordered_tableofcontents.map{|i| (i.instance_of? NestedOrderedTableOfContents) ? "#{i.tableofcontents.first}$#{i.index.first}" : i }.select(&:present?)
          ordered_typical_age_range_labels = nested_ordered_typical_age_range.map{|i| (i.instance_of? NestedOrderedTypicalAgeRange) ? "#{i.typical_age_range.first}$#{i.index.first}" : i }.select(&:present?)

          doc[ActiveFedora.index_field_mapper.solr_name("nested_geo_label", :symbol)] = labels
          doc[ActiveFedora.index_field_mapper.solr_name("nested_geo_label", :stored_searchable)] = labels
          doc[ActiveFedora.index_field_mapper.solr_name("nested_related_items_label", :symbol)] = related_items_labels
          doc[ActiveFedora.index_field_mapper.solr_name("nested_related_items_label", :stored_searchable)] = related_items_labels
          doc[ActiveFedora.index_field_mapper.solr_name("nested_ordered_creator_label", :symbol)] = ordered_creator_labels
          doc[ActiveFedora.index_field_mapper.solr_name("nested_ordered_creator_label", :stored_searchable)] = ordered_creator_labels
          doc[ActiveFedora.index_field_mapper.solr_name("nested_ordered_title_label", :symbol)] = ordered_title_labels
          doc[ActiveFedora.index_field_mapper.solr_name("nested_ordered_title_label", :stored_searchable)] = ordered_title_labels
          doc[ActiveFedora.index_field_mapper.solr_name("nested_ordered_alt_title_label", :symbol)] = ordered_alt_title_labels
          doc[ActiveFedora.index_field_mapper.solr_name("nested_ordered_alt_title_label", :stored_searchable)] = ordered_alt_title_labels
          doc[ActiveFedora.index_field_mapper.solr_name("nested_ordered_abstract_label", :symbol)] = ordered_abstract_labels
          doc[ActiveFedora.index_field_mapper.solr_name("nested_ordered_abstract_label", :stored_searchable)] = ordered_abstract_labels
          doc[ActiveFedora.index_field_mapper.solr_name("nested_ordered_contributor_label", :symbol)] = ordered_contributor_labels
          doc[ActiveFedora.index_field_mapper.solr_name("nested_ordered_contributor_label", :stored_searchable)] = ordered_contributor_labels
          doc[ActiveFedora.index_field_mapper.solr_name("nested_ordered_description_label", :symbol)] = ordered_description_labels
          doc[ActiveFedora.index_field_mapper.solr_name("nested_ordered_description_label", :stored_searchable)] = ordered_description_labels
          doc[ActiveFedora.index_field_mapper.solr_name("nested_ordered_editor_label", :symbol)] = ordered_editor_labels
          doc[ActiveFedora.index_field_mapper.solr_name("nested_ordered_editor_label", :stored_searchable)] = ordered_editor_labels
          doc[ActiveFedora.index_field_mapper.solr_name("nested_ordered_tableofcontents_label", :symbol)] = ordered_tableofcontents_labels
          doc[ActiveFedora.index_field_mapper.solr_name("nested_ordered_tibleofcontents_label", :stored_searchable)] = ordered_tableofcontents_labels
          doc[ActiveFedora.index_field_mapper.solr_name("nested_ordered_typical_age_range_label", :symbol)] = ordered_typical_age_range_labels
          doc[ActiveFedora.index_field_mapper.solr_name("nested_ordered_typical_age_range_label", :stored_searchable)] = ordered_typical_age_range_labels
          doc[ActiveFedora.index_field_mapper.solr_name("rights_statement", :facetable)] = rights_statement.first
          doc[ActiveFedora.index_field_mapper.solr_name("license", :facetable)] = license.first
        end
      end
    end
  end
end
