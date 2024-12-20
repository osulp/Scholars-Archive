# frozen_string_literal: true

module ScholarsArchive::TriplePoweredProperties
  # Makes form triple powered
  module TriplePoweredForm
    ##
    # Checks the model of this form to evaluate if a property is triple powered
    # @param property [Symbol] the models property to be evaluated
    # @return [Boolean] true if the models triple_powered_properties includes the property
    def has_triple_powered_property?(property)
      model.triple_powered_properties.include?(property[:field])
    end
  end
end
