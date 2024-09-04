# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work UndergraduateThesisOrProject`
module Hyrax
  # form object for undergraduate thesis or project
  class UndergraduateThesisOrProjectForm < DefaultForm
    include ::ScholarsArchive::TriplePoweredProperties::TriplePoweredForm
    include ScholarsArchive::EtdWorkFormBehavior

    self.model_class = ::UndergraduateThesisOrProject
    self.required_fields -= [:other_affiliation]

    def primary_terms
      t = ::ScholarsArchive::EtdTerms.primary_terms
      return t.insert(1, :alternative_title) if current_ability.current_user.admin?

      t
    end

    def secondary_terms
      t = ::ScholarsArchive::EtdTerms.secondary_terms
      t << (::ScholarsArchive::EtdTerms.admin_terms - [:in_series]) if current_ability.current_user.admin?
      t.flatten
    end
  end
end
