class EtdPresenter < DefaultWorkPresenter
  delegate :contributor_advisor, :contributor_committeemember, :degree_discipline, :degree_level, :degree_name, :degree_field, :degree_grantors, :graduation_year, to: :solr_document
end
