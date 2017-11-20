Hyrax::Workflow::StatusListService.class_eval do 
  def search_solr
    if @filter_condition && @filter_condition.start_with?('-')
      @filter_condition = "-workflow_state_name_ssim:Deposited"
    else
      @filter_condition = "workflow_state_name_ssim:Deposited"
    end
    actionable_roles = roles_for_user
    logger.debug("Actionable roles for #{user.user_key} are #{actionable_roles}")
    return [] if actionable_roles.empty?
    Hyrax::WorkRelation.new.search_with_conditions(query(actionable_roles), {df: 'actionable_workflow_roles', defType: 'edismax', rows: 1000, method: :post, fq: @filter_condition })
  end
end
