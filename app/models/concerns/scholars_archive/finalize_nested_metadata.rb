# frozen_string_literal: true

module ScholarsArchive
  # Finalize default metadata. This was split from ScholarsArchive::DefaultMetadata because FileSets need to call these AFTER ::Hyrax::FileSetBehavior is included
  # But properties from ::ScholarsArchive::DefaultMetadata needs to be defined BEFORE ::Hyrax::FileSetBehavior is included (because it calls accepts_nested_attributes_for)
  module FinalizeNestedMetadata
    extend ActiveSupport::Concern

    # Usage notes and expectations can be found in the Metadata Application Profile:
    #   https://docs.google.com/spreadsheets/d/1koKjV7bjn7v4r5a3gsowEimljHiAwbwuOgjHe7FEtuw/edit?usp=sharing

    included do
      accepts_nested_attributes_for :based_near, allow_destroy: true, reject_if: proc { |a| a[:id].blank? }
      accepts_nested_attributes_for :funding_body, allow_destroy: true, reject_if: proc { |a| a[:id].blank? }
      accepts_nested_attributes_for :nested_geo, allow_destroy: true, reject_if: :all_blank
      accepts_nested_attributes_for :nested_related_items, allow_destroy: true, reject_if: :all_blank
      # reject if all attributes all blank OR if either index or creator is blank
      accepts_nested_attributes_for :nested_ordered_title, allow_destroy: true, reject_if: proc { |attributes| attributes[:title].blank? || attributes.all? { |key, value| key == '_destroy' || value.blank? } }
      accepts_nested_attributes_for :nested_ordered_creator, allow_destroy: true, reject_if: proc { |attributes| attributes[:creator].blank? || attributes.all? { |key, value| key == '_destroy' || value.blank? } }
      accepts_nested_attributes_for :nested_ordered_abstract, allow_destroy: true, reject_if: proc { |attributes| attributes[:abstract].blank? || attributes.all? { |key, value| key == '_destroy' || value.blank? } }
      accepts_nested_attributes_for :nested_ordered_contributor, allow_destroy: true, reject_if: proc { |attributes| attributes[:contributor].blank? || attributes.all? { |key, value| key == '_destroy' || value.blank? } }
      accepts_nested_attributes_for :nested_ordered_additional_information, allow_destroy: true, reject_if: proc { |attributes| attributes[:additional_information].blank? || attributes.all? { |key, value| key == '_destroy' || value.blank? } }
    end
  end
end
