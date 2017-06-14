# Generated via
#  `rails generate hyrax:work TechnicalReport`
module Hyrax
  class TechnicalReportForm < Hyrax::DefaultWorkForm
    include ScholarsArchive::NestedGeoBehavior
    self.model_class = ::TechnicalReport
  end
end
