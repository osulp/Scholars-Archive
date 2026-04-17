# frozen_string_literal:true

Rails.application.config.to_prepare do
  Hyrax::Forms::FileSetEditForm.class_eval do
    # Add embargo_reason & ext_relation & oembed_url to permited FileSet terms
    self.terms += %i[embargo_reason ext_relation oembed_url]
  end
end
