# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work GraduateProject`
module Hyrax
  # form object for graduate project
  class GraduateProjectForm < DefaultForm
    self.model_class = ::GraduateProject

    include ::ScholarsArchive::TriplePoweredProperties::TriplePoweredForm
    include ScholarsArchive::EtdWorkFormBehavior
  end
end
