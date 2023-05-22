# frozen_string_literal: true

module ScholarsArchive::Validators
  # Validate labels and presence of related item
  class NestedRelatedItemsValidator < ActiveModel::Validator
    def validate(_record)
      validate_nested_fields record, error_counter if nested_related_items_present? (record)
    end

    def validate_nested_fields(record, error_counter = 0)
      # TODO: add appropriate validation rules here to check for lat/lon coordinates and then close Milestone 3 issue: https://github.com/osulp/Scholars-Archive/issues/397

      record.nested_related_items.each do |item|
        validate_related_item(item, record)
      end

      error_counter
    end

    def nested_related_items_present?(record)
      record.nested_related_items.present?
    end

    def validate_related_item(item, record)
      error_counter = 0
      unless item.label.first.blank? && item.related_url.first.blank?
        # check if label is present
        if item.label.first.blank? && item._destroy == false
          add_error_message(record, :related_items, I18n.translate(:"simple_form.actor_validation.nested_related_items_value_missing"))
          error_counter += 1
        end
        # check if related_url is present
        if item.related_url.first.blank? && item._destroy == false
          add_error_message(record, :related_items, I18n.translate(:"simple_form.actor_validation.nested_related_items_value_missing"))
          error_counter += 1
        end

        # process item before returning so that they can be updated in the form
        if error_counter > 0 && item._destroy == false
          related_item = record.nested_related_items.to_a.find { |i| i.label.first == item.label.first && i.related_url.first == item.related_url.first }
          related_item.validation_msg = I18n.translate(:"simple_form.actor_validation.nested_related_item_value_missing") if related_item.present?
        end
      end

      error_counter <= 0
    end

    private

    def add_error_message(record, field, error_msg)
      record.errors[field.to_s] << error_msg
    end
  end
end
