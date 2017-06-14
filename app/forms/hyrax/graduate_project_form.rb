# Generated via
#  `rails generate hyrax:work GraduateProject`
module Hyrax
  class GraduateProjectForm < Hyrax::EtdForm
    include ScholarsArchive::NestedGeoBehavior
    self.model_class = ::GraduateProject
  end
end
