# app/presenters/default_work_presenter.rb
class DefaultWorkPresenter < Hyrax::WorkShowPresenter
  delegate :date_accepted, :date_available, :date_collected, :date_copyright, :date_issued, :date_valid, to: :solr_document
end
