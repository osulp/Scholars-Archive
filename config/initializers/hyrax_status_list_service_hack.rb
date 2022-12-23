Hyrax::Workflow::StatusListService.class_eval do
  def roles_for_admin(user, responsibilities)
    AdminSet.all.each do |admin_set|
      available_workflows = admin_set.permission_template.available_workflows
      available_workflows.each do |workflow|
        ['approving','depositing','managing'].each do |role_name|
          responsibilities << "#{admin_set.id}-#{workflow.name}-#{role_name}"
        end
      end
    end
    logger.debug("Workflow responsibilities for admin #{user.user_key} are #{responsibilities}")

    # solr query for admin user responsibilities
    "{!terms f=actionable_workflow_roles_ssim}#{responsibilities.join(',')}"
  end

  def search_solr
    # Filtering for deposited or not deposited now happens here, we are using the @filter_condition variable available at
    # https://github.com/samvera/hyrax/blob/v2.0.0/app/services/hyrax/workflow/status_list_service.rb#L9

    actionable_roles = roles_for_user

    logger.debug("Actionable roles for #{user.user_key} are #{actionable_roles}")
    responsibilities = []

    if @filter_condition && @filter_condition.start_with?('-')
      # Exclude deposited and tombstoned items from the review queue
      @filter_condition = "-workflow_state_name_ssim:Deposited AND -workflow_state_name_ssim:deposited AND -workflow_state_name_ssim:tombstoned"
      return ActiveFedora::SolrService.query(roles_for_admin(user, responsibilities), {:fl => '', :fq => @filter_condition, :rows => 1000, :sort => 'id asc', :method => :post}) if user.admin?

      return [] if actionable_roles.empty? || user.sipity_agent.workflow_responsibilities.empty?

      user.sipity_agent.workflow_responsibilities.each do |r|
        admin_set_id = r.workflow_role.workflow.permission_template.source_id
        role_name = r.workflow_role.role.name
        workflow_name = r.workflow_role.workflow.name
        responsibilities << "#{admin_set_id}-#{workflow_name}-#{role_name}"
      end
      logger.debug("Workflow responsibilities for #{user.user_key} are #{responsibilities}")
      solr_query_str = "{!terms f=actionable_workflow_roles_ssim}#{responsibilities.join(',')}"
      return ActiveFedora::SolrService.query(solr_query_str, {:fl => '', :fq => @filter_condition, :rows => 1000, :sort => 'id asc', :method => :post})
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
