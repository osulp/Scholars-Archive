# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work GraduateProject`
module Hyrax
  # form object for graduate project
  class GraduateProjectForm < DefaultForm
    include ::ScholarsArchive::TriplePoweredProperties::TriplePoweredForm
    include ScholarsArchive::EtdWorkFormBehavior

    self.model_class = ::GraduateProject

    def primary_terms
      t = ::ScholarsArchive::EtdTerms.primary_terms
      return t.insert(1, :alternative_title) if current_ability.current_user.admin?

      t
    end
  end
end
