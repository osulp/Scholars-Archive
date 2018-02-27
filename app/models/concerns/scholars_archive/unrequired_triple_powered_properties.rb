module ScholarsArchive
  module UnrequiredTriplePoweredProperties
    extend ActiveSupport::Concern

    included do

      def unrequirerd_triple_powered_properties
        [:degree_grantors]
      end
    end
  end
end
