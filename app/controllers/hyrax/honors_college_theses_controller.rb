# Generated via
#  `rails generate hyrax:work HonorsCollegeThesis`

module Hyrax
  class HonorsCollegeThesesController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include ScholarsArchive::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = ::HonorsCollegeThesis

    # Use this line if you want to use a custom presenter
    self.show_presenter = HonorsCollegeThesisPresenter

    def new
      curation_concern.resource_type = ["Honors College Thesis"]
      curation_concern.other_affiliation = ["http://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege"]
      super
    end
  end
end
