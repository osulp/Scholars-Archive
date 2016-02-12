class ContentBlocksController < ApplicationController
  load_and_authorize_resource except: [:index, :destroy]
  before_action :load_featured_researchers, only: :index
  before_action :verify_is_admin, only: :destroy
  authorize_resource only: :index

  def index
  end

  def create
    @content_block.save
    redirect_to :back
  end

  def update
    @content_block.update(update_params)
    redirect_to :back
  end

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

    def create_params
      params.require(:content_block).permit([:name, :value, :external_key])
    end

    def update_params
      params.require(:content_block).permit([:value, :external_key])
    end

    def load_featured_researchers
      @content_blocks = ContentBlock.recent_researchers.page(params[:page])
    end

    def verify_is_admin
      unless current_user && current_user.group_list.include?("admin")
        flash[:error] = "You do not have the proper permissions to take this action."
        redirect_to :back
      end
    end
end
