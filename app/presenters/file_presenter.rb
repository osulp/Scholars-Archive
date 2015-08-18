# app/presenters/file_presenter.rb
class FilePresenter < Sufia::GenericFilePresenter
  self.terms += ScholarsArchiveSchema.properties.map(&:name) + [:nested_authors]
  self.terms -= [:subject, :keyword]

  def nested_authors_attributes=(attributes)
    object.nested_authors_attributes = attributes
  end
end
