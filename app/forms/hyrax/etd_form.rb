# Generated via
#  `rails generate hyrax:work Etd`
module Hyrax
  class EtdForm < Hyrax::Forms::WorkForm
    self.model_class = ::Etd
    self.terms += [:resource_type, :replaces]

    def date_terms
      []
    end
  end
end
