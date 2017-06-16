# Generated via
#  `rails generate hyrax:work Default`
module Hyrax
  class DefaultForm < Hyrax::DefaultWorkForm
    include ScholarsArchive::NestedGeoBehavior
    self.model_class = ::Default
  end
end
