# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work TechnicalReport`
module Hyrax
  # form object for technical report
  class TechnicalReportForm < DefaultForm
    include ::ScholarsArchive::TriplePoweredProperties::TriplePoweredForm

    self.model_class = ::TechnicalReport

    def primary_terms
      ::ScholarsArchive::DefaultTerms.primary_terms - %i[degree_level degree_name degree_field contributor_advisor accessibility_feature accessibility_summary] + %i[contributor_advisor degree_level degree_name degree_field accessibility_feature accessibility_summary]
    end
  end
end
