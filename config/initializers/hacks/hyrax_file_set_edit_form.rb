# frozen_string_literal:true

Rails.application.config.to_prepare do
  Hyrax::Forms::FileSetEditForm.class_eval do
    # Add embargo_reason to permited FileSet terms
    self.terms += [:embargo_reason]
  end
end
