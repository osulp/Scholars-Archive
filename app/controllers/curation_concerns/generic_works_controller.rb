# Generated via
#  `rails generate curation_concerns:work GenericWork`

module CurationConcerns
  class GenericWorksController < ApplicationController
    include CurationConcerns::CurationConcernController
  # Adds Sufia behaviors to the controller.
  include Sufia::WorksControllerBehavior

    self.curation_concern_type = GenericWork

    def new
      curation_concern.publisher = ["Oregon State University"]
      curation_concern.language = ["English"]
      super
    end
  end
end
