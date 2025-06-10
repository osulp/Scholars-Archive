# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work ExternalDataset`
module Hyrax
  # Generated form for ExternalDataset
  class ExternalDatasetForm < Hyrax::Forms::WorkForm
    include ::ScholarsArchive::TriplePoweredProperties::TriplePoweredForm
    include ScholarsArchive::DatasetFormBehavior

    self.model_class = ::ExternalDataset
    self.field_metadata_service = ScholarsArchive::FormMetadataService
  end
end
