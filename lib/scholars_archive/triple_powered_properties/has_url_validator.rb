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
        if ScholarsArchive::FormMetadataService.multiple? record.to_model.class, prop[:field]
          values = record[prop[:field]]
        else
          values = Array(record[prop[:field]])
        end

        return if values.include? 'Other'

        values.each do |value|
          begin
            uri = URI.parse(value)
          rescue
            record.errors[prop[:field]] << "#{value} is not a URL"
          else
            record.errors[prop[:field]] << "#{value} is invalid" unless uri.kind_of?(URI::HTTP)
          end
        end
      end
    end
  end
end
