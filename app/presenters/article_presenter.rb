class ArticlePresenter < DefaultWorkPresenter
  delegate :editor, :has_volume, :has_number, :conference_location, :conference_name, :conference_section, :has_journal, :is_referenced_by, :isbn, to: :solr_document
end
