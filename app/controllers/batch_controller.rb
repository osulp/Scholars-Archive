# app/controllers/batch_controller.rb
class BatchController < ApplicationController
  include ScholarsArchive::BatchControllerBehavior
  self.edit_form_class = BatchEditForm

  protected

  def edit_form
    generic_file = ::GenericFile.new(default_values)
    edit_form_class.new(generic_file)
  end

  def default_values
    {
      "creator" => [current_user.name],
      "title" => @batch.generic_files.map(&:label),
      "publisher" => [TriplePoweredResource.new(RDF::URI(I18n.t('form_defaults.publisher')))],
      "language" => [I18n.t(TriplePoweredResource.new(RDF::URI(I18n.t('form_defaults.language_uri'))), :default => 'English')]
    }
  end

end
