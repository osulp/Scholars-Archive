# Generated via
#  `rails generate curation_concerns:work GenericWork`

class CurationConcerns::GenericWorksController < ApplicationController
  include CurationConcerns::CurationConcernController
  # Adds Sufia behaviors to the controller.
  include Sufia::WorksControllerBehavior

  self.curation_concern_type = GenericWork
end
