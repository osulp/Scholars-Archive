module CurationConcerns
  class FileSetsController < ApplicationController
    include CurationConcerns::FileSetsControllerBehavior
    include Sufia::Controller
    include Sufia::FileSetsControllerBehavior
    include ScholarsArchive::StatsControllerBehavior
  end
end
