# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work Default`
class DefaultPresenter < Hyrax::WorkShowPresenter
  include ScholarsArchive::DefaultPresenterBehavior
  # Adds behaviors for hyrax-doi plugin.
  include Hyrax::DOI::DOIPresenterBehavior
  # Adds behaviors for DataCite DOIs via hyrax-doi plugin.
  include Hyrax::DOI::DataCiteDOIPresenterBehavior
end
