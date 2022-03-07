# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work Default`
module Hyrax
  # form object for default work
  class DefaultForm < Hyrax::Forms::WorkForm
    include ::ScholarsArchive::TriplePoweredProperties::TriplePoweredForm
    include ScholarsArchive::DefaultWorkFormBehavior
    # Adds behaviors for hyrax-doi plugin.
    include Hyrax::DOI::DOIFormBehavior
    # Adds behaviors for DataCite DOIs via hyrax-doi plugin.
    include Hyrax::DOI::DataCiteDOIFormBehavior

    self.model_class = ::Default
    self.field_metadata_service = ScholarsArchive::FormMetadataService
  end
end
