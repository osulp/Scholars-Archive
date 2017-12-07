Hyrax::Workflow::StatusListService.class_eval do
  def search_solr
    # Filtering for deposited or not deposited now happens here, we are using the @filter_condition variable available at
    # https://github.com/samvera/hyrax/blob/v2.0.0/app/services/hyrax/workflow/status_list_service.rb#L9

    actionable_roles = roles_for_user

    logger.debug("Actionable roles for #{user.user_key} are #{actionable_roles}")

    if @filter_condition && @filter_condition.start_with?('-')
      @filter_condition = "-workflow_state_name_ssim:Deposited AND -workflow_state_name_ssim:deposited"

      return [] if actionable_roles.empty? || user.sipity_agent.workflow_responsibilities.empty?
      responsibilities = []
      user.sipity_agent.workflow_responsibilities.each do |r|
        admin_set_id = r.workflow_role.workflow.permission_template.admin_set_id
        role_name = r.workflow_role.role.name
        workflow_name = r.workflow_role.workflow.name
        responsibilities << URI.encode("#{admin_set_id}-#{workflow_name}-#{role_name}")
      end
      logger.debug("Workflow responsibilities for #{user.user_key} are #{responsibilities}")
      actionable_roles = responsibilities
    else
      @filter_condition = "workflow_state_name_ssim:Deposited OR workflow_state_name_ssim:deposited"
      return [] if actionable_roles.empty?
    end

    # Notes:
    # - Added df: 'actionable_workflow_roles' and defType: 'edismax' to resolve https://github.com/osulp/Scholars-Archive/issues/765
    #   Submitted ticket in hyrax to report issue 765: https://github.com/samvera/hyrax/issues/1395
    # - Added fq: @filter_condition to resolve https://github.com/osulp/Scholars-Archive/issues/1028
    Hyrax::WorkRelation.new.search_with_conditions(query(actionable_roles), {df: 'actionable_workflow_roles', defType: 'edismax', rows: 1000, method: :post, fq: @filter_condition })
  end
end
