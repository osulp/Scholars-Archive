class DeleteContentBlocksController < ContentBlocksController
  def destroy
    @researcher = ContentBlock.find(params[:id])
    if @researcher.destroy
      flash[:success] = "Sucessfully deleted."
    else
      flash[:error] = "Error while deleting Featured Researcher."
    end 
    redirect_to :back
  end
end
