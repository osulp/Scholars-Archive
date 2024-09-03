# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work GraduateThesisOrDissertation`
module Hyrax
  # form object for graduate thesis or dissertation
  class GraduateThesisOrDissertationForm < DefaultForm
    include ::ScholarsArchive::TriplePoweredProperties::TriplePoweredForm
    include ScholarsArchive::EtdWorkFormBehavior

    self.model_class = ::GraduateThesisOrDissertation

    def secondary_terms
      t = ::ScholarsArchive::EtdTerms.secondary_terms
      t << (::ScholarsArchive::EtdTerms.admin_terms - [:in_series]) if current_ability.current_user.admin?
      t.flatten
    end
  end
end
