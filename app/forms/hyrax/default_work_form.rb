# Generated via
#  `rails generate hyrax:work DefaultWork`
module Hyrax
  class DefaultWorkForm < Hyrax::Forms::WorkForm
    self.model_class = ::DefaultWork
    self.terms += [:resource_type]
  end
end
