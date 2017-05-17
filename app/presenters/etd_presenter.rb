class EtdPresenter < Hyrax::WorkShowPresenter
  delegate :date_accepted, :date_available, :date_collected, :date_copyright, :date_issued, :replaces, :date_valid, to: :solr_document
end
