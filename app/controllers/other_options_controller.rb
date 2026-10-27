# frozen_string_literal: true

# other options controller
class OtherOptionsController < ApplicationController
  before_action :authenticate_user!, only: %i[destroy]

  def destroy
    authorize! :edit, ActiveFedora::Base
    @other_option = OtherOption.destroy(params[:id])

    respond_to do |f|
      f.js
      f.html { redirect_to root_path }
    end
  end
end
