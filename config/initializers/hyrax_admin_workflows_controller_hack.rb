Hyrax::Admin::WorkflowsController.class_eval do
  def per_page
    @per_page ||= params.fetch('per_page', 100000).to_i
  end
end
