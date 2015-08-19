# app/controllers/batch_controller.rb
class BatchController < ApplicationController
  include Sufia::BatchControllerBehavior
  self.edit_form_class = BatchEditForm

  def edit
    super
    defaults_object.set_default_values
  end

  private 

  def defaults_object
    DefaultValuesObject.new(@form)
  end

end
