# frozen_string_literal: true

# test
module Bulkrax
  # test
  module HasLocalProcessing
    # Override the factory to use a customized version
    def factory
      @factory ||= Bulkrax::ScholarsArchiveObjectFactory.new(attributes: parsed_metadata, source_identifier_value: identifier, work_identifier: work_identifier, importer_run_id: importerexporter.last_run.id, replace_files: replace_files, user: user, klass: factory_class, update_files: update_files, work_identifier_search_field: 'bulkrax_identifier_sim')
    end

    # This method is called during build_metadata
    # add any special processing here, for example to reset a metadata property
    # to add a custom property from outside of the import data
    #
    # Transform attribute properties for the factory
    # rubocop:disable Metrics/MethodLength
    def add_local
      properties_with_classes.each_pair do |key, new_key|
        next unless parsed_metadata[key].present?

        # use custom matchers for field parsers, already processed
        if %w[nested_ordered_title nested_ordered_creator nested_ordered_contributor nested_ordered_abstract nested_ordered_additional_information].include? key
          parsed_metadata[new_key] = parsed_metadata[key]

        elsif parsed_metadata[key].is_a?(String)
          parsed_metadata[new_key]['0'] = { id: parsed_metadata[key] }

        else
          parsed_metadata[new_key] = {}
          parsed_metadata[key].each_with_index do |value, index|
            parsed_metadata[new_key][index.to_s] = { id: value }
          end
        end
        parsed_metadata.delete(key)
      end
    end
    # rubocop:enable Metrics/MethodLength

    # Return a hash of property : property_attibutes pairs
    def properties_with_classes
      factory_class.properties.keys.map { |k| { k => "#{k}_attributes" } if factory_class.properties[k].class_name&.to_s&.include? 'Nested' }.compact.inject(:merge)

      # includes academic_affiliation, based_near, funding_body - SA doesn't want hash for those (though check code updates from Brandon for academic_affiliation)
      # factory_class.properties.keys.map { |k| { k => "#{k}_attributes" } if factory_class.properties[k].class_name }.compact.inject(:merge)
    end
  end
end
