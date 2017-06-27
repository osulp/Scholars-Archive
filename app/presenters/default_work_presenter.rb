# app/presenters/default_work_presenter.rb
class DefaultWorkPresenter < Hyrax::WorkShowPresenter
  delegate :relation, :other_affiliation, :academic_affiliation, :doi, :rights_statement_label, :license_label, :language_label, :abstract, :alt_title , :license, :based_near, :resource_type, :date_available, :date_copyright, :date_issued, :date_collected, :date_valid, :date_accepted, :replaces, :hydrologic_unit_code, :funding_body, :funding_statement, :in_series, :tableofcontents, :bibliographic_citation, :peerreviewed, :additional_information, :digitization_spec, :file_extent, :file_format, :dspace_community, :dspace_collection, :itemtype, :nested_geo, to: :solr_document
end
