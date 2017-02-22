# Generated via
#  `rails generate hyrax:work Etd`
module Hyrax
  class EtdForm < Hyrax::Forms::WorkForm
    self.model_class = ::Etd
    self.terms += [:date_graduate, :date_copyright, :contributor_advisor, :contributor_committeemember, :degree_name, :degree_field, :degree_discipline, :degree_level, :degree_grantor, :resource_type]
    self.terms -= [:contributor, :based_near, :related_url, :source, :identifier]
    self.required_fields -= [:keyword, :creator]
  end
end
