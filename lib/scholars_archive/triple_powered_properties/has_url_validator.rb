# frozen_string_literal: true

require 'uri'

module ScholarsArchive::TriplePoweredProperties
  class HasUrlValidator < ActiveModel::Validator
    ##
    # Evaluate each triple powered property value to ensure it is a valid URL
    #
    # @param record [ActiveModel] the model being validated
    def validate(record)
      return if record.triple_powered_properties.empty?

      record.triple_powered_properties.each do |prop|
        return if prop[:skip_validation] && record[prop].empty?

        values = if ScholarsArchive::FormMetadataService.multiple? record.to_model.class, prop[:field]
                   record[prop[:field]]
                 else
                   Array(record[prop[:field]])
                 end

        return if values.include? 'Other'

        values.each do |value|
          uri = URI.parse(value)
        rescue StandardError
          record.errors[prop[:field]] << "#{value} is not a URL"
        else
          record.errors[prop[:field]] << "#{value} is invalid" unless uri.is_a?(URI::HTTP)
        end
      end
    end
  end
end
