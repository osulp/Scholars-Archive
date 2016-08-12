class DeleteFeaturedResearchersController < ApplicationController
  before_action :verify_is_admin, only: :destroy

  def destroy
    @researcher = ContentBlock.find(params[:id])
    if @researcher.destroy
      flash[:success] = "Sucessfully deleted."
    else
      flash[:error] = "Error in deleting entry."
    end 
    redirect_to :back
  end

  protected

  def verify_is_admin
    unless current_user && current_user.admin?
      flash[:error] = "You do not have the proper permissions to take this action."
      redirect_to :back
    end
  end
end
