# app/presenters/my_generic_file_presenter.rb
class MyGenericFilePresenter < Sufia::GenericFilePresenter
  self.terms = [:resource_type, :title, :creator, :contributor, :description,
                :tag, :rights, :publisher, :date_created, :subject, :language,
                :identifier, :based_near, :related_url, :spatial]
end
