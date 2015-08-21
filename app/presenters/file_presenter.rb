# app/presenters/file_presenter.rb
class FilePresenter < Sufia::GenericFilePresenter
  self.terms += ScholarsArchiveSchema.properties.map(&:name) + [:nested_authors]
  self.terms -= [:subject, :keyword]
  delegate :nested_authors_attributes=, :to => :model
end
