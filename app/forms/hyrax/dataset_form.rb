# Generated via
#  `rails generate hyrax:work Dataset`
module Hyrax
  class DatasetForm < Hyrax::DefaultWorkForm
    include ScholarsArchive::NestedGeoBehavior

    self.model_class = ::Dataset
  end
end
