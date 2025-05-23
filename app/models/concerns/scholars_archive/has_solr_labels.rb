# frozen_string_literal: true

module ScholarsArchive
  # solr label ops
  module HasSolrLabels
    extend ActiveSupport::Concern

    included do
      def to_solr(solr_doc = {})
        super.tap do |doc|
          nested_geo.each do |geo|
            next unless geo.instance_of? NestedGeo

            if geo.point.present? && geo.type.blank?
              geo.point = "#{geo.label.first} (#{geo.point.first})"
              geo.type = :point.to_s
            end
            if geo.bbox.present? && geo.type.blank?
              geo.bbox = "#{geo.label.first} (#{geo.bbox.first})"
              geo.type = :bbox.to_s
            end
          end
          point_labels = nested_geo.flat_map { |i| i.instance_of?(NestedGeo) ? i.point : '' }.select(&:present?).flatten.map { |i| i[0] }
          bbox_labels = nested_geo.flat_map { |i| i.instance_of?(NestedGeo) ? i.bbox : '' }.select(&:present?).flatten.map { |i| i[0] }
          labels = point_labels + bbox_labels
          related_items_labels = nested_related_items.map { |i| i.instance_of?(NestedRelatedItems) ? "#{i.label.first}$#{i.related_url.first}$#{i.index.first}" : i }.select(&:present?)
          ordered_creator_labels = nested_ordered_creator.map { |i| i.instance_of?(NestedOrderedCreator) ? "#{i.creator.first}$#{i.index.first}" : i }.select(&:present?)
          creator_labels = nested_ordered_creator.map { |i| i.instance_of?(NestedOrderedCreator) ? i.creator.first.to_s : i }.select(&:present?).uniq
          ordered_title_labels = nested_ordered_title.map { |i| i.instance_of?(NestedOrderedTitle) ? "#{i.title.first}$#{i.index.first}" : i }.select(&:present?)
          ordered_abstract_labels = nested_ordered_abstract.map { |i| i.instance_of?(NestedOrderedAbstract) ? "#{i.abstract.first}$#{i.index.first}" : i }.select(&:present?)
          ordered_contributor_labels = nested_ordered_contributor.map { |i| i.instance_of?(NestedOrderedContributor) ? "#{i.contributor.first}$#{i.index.first}" : i }.select(&:present?)
          contributor_labels = nested_ordered_contributor.map { |i| i.instance_of?(NestedOrderedContributor) ? i.contributor.first.to_s : i }.select(&:present?).uniq
          ordered_additional_information_labels = nested_ordered_additional_information.map { |i| i.instance_of?(NestedOrderedAdditionalInformation) ? "#{i.additional_information.first}$#{i.index.first}" : i }.select(&:present?)

          labels = [{ label: 'nested_geo_label', data: labels },
                    { label: 'nested_related_items_label', data: related_items_labels },
                    { label: 'nested_ordered_creator_label', data: ordered_creator_labels },
                    { label: 'nested_ordered_title_label', data: ordered_title_labels },
                    { label: 'nested_ordered_abstract_label', data: ordered_abstract_labels },
                    { label: 'nested_ordered_contributor_label', data: ordered_contributor_labels },
                    { label: 'nested_ordered_additional_information_label', data: ordered_additional_information_labels }]

          labels.each do |label_set|
            doc["#{label_set[:label]}_ssim"] = label_set[:data]
            doc["#{label_set[:label]}_tesim"] = label_set[:data]
          end
          if ordered_title_labels.present?
            ordered_titles = nested_ordered_title.select { |i| i.instance_of?(NestedOrderedTitle) ? (i.title.present? && i.index.present?) : i.present? }.map { |i| i.instance_of?(NestedOrderedTitle) ? [i.title.first, i.index.first] : [i] }.select(&:present?).sort_by(&:second).map(&:first)

            doc['title_tesim'] = ordered_titles
            doc['nested_ordered_title_label_tesim'] = ordered_titles
          end

          doc[ActiveFedora.index_field_mapper.solr_name('rights_statement', :facetable)] = rights_statement.first
          doc[ActiveFedora.index_field_mapper.solr_name('license', :facetable)] = license.first
          doc['creator_sim'] = creator_labels
          doc['contributor_sim'] = contributor_labels
        end
      end
    end
  end
end
