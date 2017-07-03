class ArticlePresenter < DefaultWorkPresenter
  delegate :conference_location,
           :conference_name,
           :conference_section,
           :editor,
           :has_journal,
           :has_number,
           :has_volume,
           :is_referenced_by,  to: :solr_document
end
