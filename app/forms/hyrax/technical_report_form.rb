# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work TechnicalReport`
module Hyrax
  class TechnicalReportForm < DefaultForm
    include ::ScholarsArchive::TriplePoweredProperties::TriplePoweredForm

    self.model_class = ::TechnicalReport
  end
end
