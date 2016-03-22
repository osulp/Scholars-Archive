# app/presenters/file_presenter.rb
class FilePresenter < Sufia::GenericFilePresenter
  self.terms -= [:language, :publisher]
  self.terms += ScholarsArchiveSchema.properties.map(&:name)
  self.terms -= [:subject, :creator, :accepted, :available, :copyrighted, :created, :issued, :submitted, :modified, :valid_date, :keyword]
  self.terms = self.terms.insert(2, :nested_authors)
  self.terms = self.terms.insert(2, :nested_geo_points)
  self.terms = self.terms.insert(2, :nested_geo_bbox)
  self.terms = self.terms.insert(2, :nested_geo_location)
  delegate :nested_authors_attributes=, :to => :model
  delegate :nested_geo_points_attributes=, :to => :model
  delegate :nested_geo_bbox_attributes=, :to => :model
  delegate :nested_geo_location_attributes=, :to => :model
end
