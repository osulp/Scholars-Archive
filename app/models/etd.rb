# Generated via
#  `rails generate hyrax:work Etd`
class Etd < ActiveFedora::Base
  include ::Hyrax::WorkBehavior

  include ::ScholarsArchive::EtdMetadata
  include ::ScholarsArchive::DefaultMetadata
  include ScholarsArchive::TriplePoweredProperties::WorkBehavior
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
  validates :title, presence: { message: 'Your work must have a title.' }

  self.human_readable_type = 'Etd'

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
