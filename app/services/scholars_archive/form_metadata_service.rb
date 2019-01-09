# frozen_string_literal: true

module ScholarsArchive
  # Form metadata
  class FormMetadataService < Hyrax::FormMetadataService
    def self.multiple?(model_class, field)
      case field.to_s
      when 'license'
        false
      else
        super
      end
    end
  end
end
