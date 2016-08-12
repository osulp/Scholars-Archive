# Generated via
#  `rails generate curation_concerns:work GenericWork`
class GenericWork < ActiveFedora::Base
  include ::CurationConcerns::WorkBehavior
  include ::CurationConcerns::BasicMetadata
  include Sufia::WorkBehavior
  self.human_readable_type = 'Work'
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []

  # TODO: Implement or include TriplePoweredResource
  # def self.property(name, options)
  #   super(name, {:class_name => TriplePoweredResource}.merge(options)) do |index|
  #     index.as :stored_searchable, :symbol
  #   end
  # end

  validates :title, presence: { message: 'Your work must have a title.' }

  def to_solr(solr_doc = {})
    super.tap do |doc|
      doc[ActiveFedora.index_field_mapper.solr_name("nested_geo_points_label", :symbol)] = nested_geo_points.flat_map(&:label).select(&:present?)
      doc[ActiveFedora.index_field_mapper.solr_name("nested_geo_points_label", :stored_searchable)] = nested_geo_points.flat_map(&:label).select(&:present?)
      doc[ActiveFedora.index_field_mapper.solr_name("nested_geo_bbox_label", :symbol)] = nested_geo_bbox.flat_map(&:label).select(&:present?)
      doc[ActiveFedora.index_field_mapper.solr_name("nested_geo_bbox_label", :stored_searchable)] = nested_geo_bbox.flat_map(&:label).select(&:present?)
      doc[ActiveFedora.index_field_mapper.solr_name("nested_geo_location_name", :symbol)] = nested_geo_location.flat_map(&:name).select(&:present?)
      doc[ActiveFedora.index_field_mapper.solr_name("nested_geo_location_name", :stored_searchable)] = nested_geo_location.flat_map(&:name).select(&:present?)
      doc[ActiveFedora.index_field_mapper.solr_name("nested_geo_location_geonames_url", :symbol)] = nested_geo_location.flat_map(&:geonames_url).select(&:present?)
      doc[ActiveFedora.index_field_mapper.solr_name("nested_geo_location_geonames_url", :stored_searchable)] = nested_geo_location.flat_map(&:geonames_url).select(&:present?)

    end
  end
end
