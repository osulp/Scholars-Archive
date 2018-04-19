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
      curation_concern.resource_type = ["Honors College Thesis"] if curation_concern.respond_to?(:resource_type)
      curation_concern.other_affiliation = ["http://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege"] if curation_concern.respond_to?(:other_affiliation)
      curation_concern.degree_level = "Bachelor's" if curation_concern.respond_to?(:degree_level)
      curation_concern.peerreviewed = "FALSE" if curation_concern.respond_to?(:peerreviewed)
      super
    end
  end
end
