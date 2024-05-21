# frozen_string_literal:true

Hyrax::CollectionSearchBuilder.class_eval do
  # Change from title_si to title_ssort since that's the field we use to sort
  # @return [String] Solr field name indicating default sort order
  def sort_field
    "title_ssort"
  end
end
