# Generated via
#  `rails generate hyrax:work GraduateProject`
module Hyrax
  class GraduateProjectForm < Hyrax::Forms::WorkForm
    include ::ScholarsArchive::TriplePoweredProperties::TriplePoweredForm
    include ScholarsArchive::DefaultWorkFormBehavior
    include ScholarsArchive::EtdWorkFormBehavior
    self.model_class = ::GraduateProject
  end
end
