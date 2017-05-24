# app/presenters/default_work_presenter.rb
class DefaultWorkPresenter < Hyrax::WorkShowPresenter
  delegate :doi, :abstract, :alt_title , :license, :based_near, :resource_type, :date_available, :date_copyright, :date_issued, :date_collected, :date_valid, :date_accepted, :replaces, :hydrologic_unit_code, :funding_body, :funding_statement, :in_series, :tableofcontents, :bibliographic_citation, :peerreviewed, :additional_information, :digitization_spec, :file_extent, :file_format, :dspace_community, :dspace_collection, to: :solr_document
end
