module ScholarsArchive 
  module OerWorkFormBehavior
    extend ActiveSupport::Concern
    included do
      self.terms += [:resource_type, :is_based_on_url, :interactivity_type, :learning_resource_type, :typical_age_range, :time_required, :duration]
      def primary_terms
        super
      end

      def secondary_terms
        super - self.date_terms + [:is_based_on_url, :interactivity_type, :learning_resource_type, :typical_age_range, :time_required, :duration]
      end
    end
  end
end
