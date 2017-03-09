# Generated via
#  `rails generate hyrax:work DefaultWork`
module Hyrax
  class DefaultWorkForm < Hyrax::Forms::WorkForm
    self.model_class = ::DefaultWork
    self.terms += [:alt_title, :date_issued, :date_available, :date_copyright, :bibliographic_citation, :doi, :identifier_uri, :isbn, :peerreviewed, :in_series, :tableofcontents, :digitization_spec, :file_extent, :file_format, :funding_statement, :funding_body, :relation, :additional_information, :resource_type]
    self.terms -= [:contributor, :based_near, :related_url, :source, :identifier]
    self.required_fields -= [:keyword, :creator]
  end
end
