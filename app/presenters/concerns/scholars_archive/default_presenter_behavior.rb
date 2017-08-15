module ScholarsArchive
  module DefaultPresenterBehavior
    extend ActiveSupport::Concern
    included do
      delegate :abstract,
               :academic_affiliation_label,
               :additional_information,
               :alt_title,
               :based_near,
               :bibliographic_citation,
               :date_accepted,
               :date_available,
               :date_collected,
               :date_copyright,
               :date_issued,
               :date_valid,
               :digitization_spec,
               :doi,
               :dspace_collection,
               :dspace_community,
               :embargo_reason,
               :file_extent,
               :file_format,
               :funding_body,
               :funding_statement,
               :hydrologic_unit_code,
               :in_series,
               :isbn,
               :issn,
               :itemtype,
               :language_label,
               :license,
               :license_label,
               :nested_geo,
               :other_affiliation_label,
               :peerreviewed_label,
               :replaces,
               :resource_type,
               :rights_statement_label,
               :tableofcontents, to: :solr_document
    end
  end
end
