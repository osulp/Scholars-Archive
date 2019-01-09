# frozen_string_literal: true

# PER presenter for show page
class PurchasedEResourcePresenter < DefaultPresenter
  include ScholarsArchive::ArticlePresenterBehavior
  include ScholarsArchive::EtdPresenterBehavior
end
