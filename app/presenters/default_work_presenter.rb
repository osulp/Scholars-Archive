class DefaultWorkPresenter < Hyrax::WorkShowPresenter
  delegate :rights_statement, to: :solr_document
end
