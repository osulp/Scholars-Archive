# app/presenters/file_presenter.rb
class FilePresenter < Sufia::GenericFilePresenter
  self.terms += ScholarsArchiveSchema.properties.map(&:name)
  self.terms -= [:subject, :creator, :accepted, :available, :copyrighted, :created, :issued, :submitted, :modified, :valid_date, :keyword]
  self.terms = self.terms.insert(2, :nested_authors)
  delegate :nested_authors_attributes=, :to => :model
end
