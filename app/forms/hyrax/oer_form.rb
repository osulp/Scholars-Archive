# Generated via
#  `rails generate hyrax:work Oer`
module Hyrax
  class OerForm < Hyrax::DefaultWorkForm
    include ScholarsArchive::DateTermsBehavior

    self.model_class = ::Oer
    self.terms += [:resource_type, :is_based_on_url, :interactivity_type, :learning_resource_type, :typical_age_range, :time_required]
    def primary_terms
      super
    end

    def secondary_terms
      super - self.date_terms 
    end
  end
end
