class EtdPresenter < DefaultWorkPresenter
  delegate :contributor_advisor,
           :contributor_committeemember,
           :degree_discipline,
           :degree_field,
           :degree_grantors,
           :degree_level,
           :degree_name,
           :graduation_year, to: :solr_document
end
