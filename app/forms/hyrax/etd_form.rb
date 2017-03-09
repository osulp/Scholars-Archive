# Generated via
#  `rails generate hyrax:work Etd`
module Hyrax
  class EtdForm < Hyrax::Forms::WorkForm
    self.model_class = ::Etd
    self.terms += [:alt_title, :date_issued, :date_available, :date_copyright, :identifier_uri, :degree_level, :degree_name, :degree_field, :degree_discipline, :degree_grantor, :contributor_advisor, :contributor_committeemember, :graduation_term, :graduation_year, :graduation_academic_year, :resource_type]
    self.terms -= [:contributor, :based_near, :related_url, :source, :identifier]
    self.required_fields -= [:keyword, :creator]
  end
end
