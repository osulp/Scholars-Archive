# app/controllers/batch_controller.rb
class BatchController < ApplicationController
  include Sufia::BatchControllerBehavior

  self.edit_form_class = BatchEditForm

  def edit
    @batch = batch_find
    @form = edit_form
    @form["publisher"] = [t('default_publisher')] if @form["publisher"].first.empty?
    @form["language"] = [RDF::URI(t('default_language_uri'))] if @form["language"].first.empty?
    @form["rights"] = [t('default_rights')] if @form["rights"].first.empty?
  end

  private

  def batch_find
    Batch.find_or_create(params[:id])
  end

end
