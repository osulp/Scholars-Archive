# frozen_string_literal: true

# OVERRIDE: This overrides create on BatchCreateJob and adds
# nested_ordered_title to the list of attributes
#
# Base file: https://github.com/samvera/hyrax/blob/v2.3.0/app/jobs/batch_create_job.rb
BatchCreateJob.class_eval do
  def create(user, titles, resource_types, uploaded_files, attributes, operation)
    model = attributes.delete(:model) || attributes.delete('model')
    raise ArgumentError, 'attributes must include "model" => ClassName.to_s' unless model

    uploaded_files.each do |upload_id|
      title = [titles[upload_id]] if titles[upload_id]
      # build hash nested_ordered_title for NestedOrderedTitle
      nested_ordered_title = { rand(DateTime.now.to_i).to_s => { 'index' => '0', 'title' => title.first.to_s } } if title.first.present?
      resource_type = Array.wrap(resource_types[upload_id]) if resource_types[upload_id]

      attributes = attributes.merge(uploaded_files: [upload_id],
                                    title: title,
                                    nested_ordered_title_attributes: nested_ordered_title,
                                    resource_type: resource_type)
      child_operation = Hyrax::Operation.create!(user: user,
                                                 operation_type: 'Create Work',
                                                 parent: operation)
      CreateWorkJob.perform_later(user, model, attributes, child_operation)
    end
  end
end
