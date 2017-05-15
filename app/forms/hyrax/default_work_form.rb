# Generated via
#  `rails generate hyrax:work DefaultWork`
module Hyrax
  class DefaultWorkForm < Hyrax::Forms::WorkForm
    include ::ScholarsArchive::TriplePoweredProperties::TriplePoweredForm
    self.model_class = ::DefaultWork
    self.terms += [:resource_type, :date_available, :date_copyright, :date_issued, :date_collected, :date_valid, :date_accepted]

    def self.build_permitted_params
      super + self.date_terms
    end

    def secondary_terms
      super - self.date_terms
    end

    def self.date_terms
      [
        :date_created,
        :date_available,
        :date_copyright,
        :date_issued,
        :date_collected,
        :date_valid,
        :date_accepted,
      ]
    end

    def date_terms
      self.class.date_terms
    end
  end
end
