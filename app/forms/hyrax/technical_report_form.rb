# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work TechnicalReport`
module Hyrax
  # form object for technical report
  class TechnicalReportForm < DefaultForm
    include ::ScholarsArchive::TriplePoweredProperties::TriplePoweredForm

    self.model_class = ::TechnicalReport

    def self.primary_terms
      super - %i[degree_level degree_name degree_field contributor_advisor]
    end
  end
end
