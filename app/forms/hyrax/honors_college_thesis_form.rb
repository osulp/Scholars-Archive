# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work HonorsCollegeThesis`
module Hyrax
  # form object for honors college thesis
  class HonorsCollegeThesisForm < DefaultForm
    self.model_class = ::HonorsCollegeThesis

    include ::ScholarsArchive::TriplePoweredProperties::TriplePoweredForm
    include ScholarsArchive::EtdWorkFormBehavior
    self.terms += [:resource_type]
    self.required_fields += %i[contributor_advisor other_affiliation]
  end
end
