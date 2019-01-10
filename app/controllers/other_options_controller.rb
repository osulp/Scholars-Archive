# frozen_string_literal: true

class OtherOptionsController < ApplicationController
  def destroy
    @other_option = OtherOption.destroy(params[:id])

    respond_to do |f|
      f.js
      f.html { redirect_to root_path }
    end
  end
end
