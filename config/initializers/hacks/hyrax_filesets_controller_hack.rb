# frozen_string_literal:true

require Hyrax::Engine.root.join('lib', 'hyrax', 'search_state.rb')
Hyrax::FileSetsController.class_eval do
  private
  def attempt_update
    if wants_to_revert?
      actor.revert_content(params[:revision])
    elsif params.key?(:file_set)
      actor.update_content(params[:file_set][:files].first)
      update_metadata
    end
  end
end
