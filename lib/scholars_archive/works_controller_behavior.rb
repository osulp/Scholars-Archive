module ScholarsArchive
  module WorksControllerBehavior
    extend ActiveSupport::Concern
    extend WorksControllerBehavior
    include Sufia::Breadcrumbs
    include Sufia::Controller
    include CurationConcerns::CurationConcernController

    included do
      self.show_presenter = ScholarsArchive::WorkShowPresenter
      layout "sufia-one-column"
    end
  end
end
