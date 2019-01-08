# frozen_string_literal: true

module ScholarsArchive
  module PurchasedEResourceWorksControllerBehavior
    extend ScholarsArchive::WorksControllerBehavior
    extend ActiveSupport::Concern
    include Hyrax::WorksControllerBehavior

    def new
      curation_concern.rights_statement = ['http://rightsstatements.org/vocab/InC/1.0/']
      super
    end
  end
end
