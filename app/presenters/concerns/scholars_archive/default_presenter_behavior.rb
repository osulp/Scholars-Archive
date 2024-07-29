# frozen_string_literal: true

module ScholarsArchive
  # presenter behavior for default
  module DefaultPresenterBehavior
    extend ActiveSupport::Concern
    included do
      delegate :abstract,
               :academic_affiliation_label,
               :based_near_linked,
               :datacite_doi,
               :degree_field_label,
               :embargo_date_range,
               :itemtype,
               :language_label,
               :license_label,
               :nested_ordered_creator_label,
               :nested_ordered_title_label,
               :nested_ordered_abstract_label,
               :nested_ordered_contributor_label,
               :nested_ordered_additional_information_label,
               :nested_related_items_label,
               :other_affiliation_label,
               :peerreviewed_label,
               :rights_statement_label, to: :solr_document
      delegate(*::ScholarsArchive::DefaultTerms.base_terms, to: :solr_document)
    end

    # METHOD: Add in a method to check if ext_relation exist & fetch the value
    def ext_relation?
      file_set_presenters.any? do |presenter|
        ext?(presenter, true)
      end
    end

    def ext_relation
      ext_url = ''

      file_set_presenters.any? do |presenter|
        ext_url = ext?(presenter, false)
      end

      ext_url
    end

    private

    def ext?(presenter, control_stm)
      control_stm ? !presenter.ext_relation.blank? : presenter.ext_relation
    end
  end
end
