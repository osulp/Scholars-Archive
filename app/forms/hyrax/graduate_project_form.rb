# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work GraduateProject`
module Hyrax
  class GraduateProjectForm < DefaultForm
    include ::ScholarsArchive::TriplePoweredProperties::TriplePoweredForm
    include ScholarsArchive::EtdWorkFormBehavior

    self.model_class = ::GraduateProject
  end
end
