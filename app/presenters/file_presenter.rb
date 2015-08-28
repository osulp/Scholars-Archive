# app/presenters/file_presenter.rb
class FilePresenter < Sufia::GenericFilePresenter
  self.terms += ScholarsArchiveSchema.properties.map(&:name)
  self.terms -= [:subject, :keyword, :creator]
  self.terms = self.terms.insert(2, :nested_authors)
  delegate :nested_authors_attributes=, :to => :model
end
