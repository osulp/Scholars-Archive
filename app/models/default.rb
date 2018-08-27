# Generated via
#  `rails generate hyrax:work Default`
class Default < ActiveFedora::Base
  include ::Hyrax::WorkBehavior
  include ::ScholarsArchive::DefaultMetadata
  include ScholarsArchive::HasSolrLabels
  include ScholarsArchive::DateOperations
  include ScholarsArchive::HasTriplePoweredProperties
  include ScholarsArchive::ExcludedDefaultLicenses

  self.indexer = DefaultWorkIndexer

  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []

  self.validates_with ScholarsArchive::Validators::OtherOptionDegreeValidator
  self.validates_with ScholarsArchive::Validators::OtherAffiliationValidator
  self.validates_with ScholarsArchive::Validators::NestedRelatedItemsValidator

  def to_s
    if title.present?
      title
    elsif nested_ordered_title.first.title.present?
      nested_ordered_title.select { |i| i.title.present? }.map{|i| (i.instance_of? NestedOrderedTitle) ? [i.title.first, i.index.first] : i }.select(&:present?).sort_by{ |array| array[1] }.map{ |array| array[0] }.first
    else
      'No Title'
    end
  end

  private
  def set_defaults
  end
end
