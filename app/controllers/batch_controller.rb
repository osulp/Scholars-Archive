# app/controllers/batch_controller.rb
class BatchController < ApplicationController
  include Sufia::BatchControllerBehavior

  self.edit_form_class = BatchEditForm

  def edit
    @batch = Batch.find_or_create(params[:id])
    @form = edit_form
    @form["publisher"] = [t('sufia.default_publisher')] if @form["publisher"].first.empty?
    @form["language"] = [RDF::URI(t('sufia.default_language_uri'))] if @form["language"].first.empty?
  end

end
