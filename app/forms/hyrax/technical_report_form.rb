# Generated via
#  `rails generate hyrax:work TechnicalReport`
module Hyrax
  class TechnicalReportForm < Hyrax::Forms::WorkForm
    include ::ScholarsArchive::TriplePoweredProperties::TriplePoweredForm
    include ScholarsArchive::DefaultWorkFormBehavior
    self.model_class = ::TechnicalReport
  end
end
