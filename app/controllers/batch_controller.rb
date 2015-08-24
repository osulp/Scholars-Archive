# app/controllers/batch_controller.rb
class BatchController < ApplicationController
  include Sufia::BatchControllerBehavior
  self.edit_form_class = BatchEditForm

  def edit
    super
    @form.instance_variable_set(:@attributes, merged_attributes)
  end

  private

  def merged_attributes
    @form.attributes.merge(sanitized_defaults) 
  end

  def sanitized_defaults
    default_values.delete_if { |key, value| !@form[key].first.empty? }
  end

  def default_values
    {
      "publisher" => [I18n.t('form_defaults.publisher')],
      "language" => [I18n.t('form_defaults.language_uri')]
    }
  end

end
