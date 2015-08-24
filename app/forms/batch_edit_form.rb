# app/forms/batch_edit_form.rb
class BatchEditForm < FileEditForm
  delegate :attributes, :to => :model
end
