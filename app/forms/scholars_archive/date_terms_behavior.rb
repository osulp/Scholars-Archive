module ScholarsArchive
  module DateTermsBehavior
    extend ActiveSupport::Concern

    included do
      def date_terms
        super
      end
    end
  end
end
