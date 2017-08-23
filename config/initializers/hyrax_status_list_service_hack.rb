Hyrax::Workflow::StatusListService.class_eval do 
  def search_solr
    actionable_roles = roles_for_user
    logger.debug("Actionable roles for #{user.user_key} are #{actionable_roles}")
    return [] if actionable_roles.empty?
    Hyrax::WorkRelation.new.search_with_conditions(query(actionable_roles), {df: 'actionable_workflow_roles', defType: 'edismax', rows: 1000})
  end
end
