# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work Dataset`
module Hyrax
  # form object for dataset
  class DatasetForm < Hyrax::Forms::WorkForm
    include ::ScholarsArchive::TriplePoweredProperties::TriplePoweredForm
    include ScholarsArchive::DatasetFormBehavior

    self.model_class = ::Dataset
    self.field_metadata_service = ScholarsArchive::FormMetadataService
  end
end
