# frozen_string_literal:true

# Implement Fix https://github.com/samvera/hyrax/pull/5920 from Hyrax v4. No longer necessary after >v4 upgrade
Hyrax::CollectionSearchBuilder.class_eval do
  # Sort results by title if no query was supplied.
  # This overrides the default 'relevance' sort.
  def add_sorting_to_solr(solr_parameters)
    return if solr_parameters[:q]
    solr_parameters[:sort] ||= sort
    solr_parameters[:sort] ||= "#{sort_field} asc"
  end
end
