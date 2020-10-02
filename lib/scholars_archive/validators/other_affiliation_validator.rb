# frozen_string_literal: true

module ScholarsArchive::Validators
  # Other affiliation validator
  class OtherAffiliationValidator < ActiveModel::Validator
    def validate(record)
      error_counter = 0

      if other_affiliation_other_present? (record)
        # check if other_affiliation_other is already in the list or is missing
        error_counter += validate_other_value_multiple? record, field: :other_affiliation, collection: other_affiliation_options(current_user_editor(record))
      end

      nil
    end

    def other_affiliation_other_present? (record)
      record.respond_to?(:other_affiliation_other) && record.other_affiliation_other.present?
    end

    def other_affiliation_options(env_user)
      service = ScholarsArchive::OtherAffiliationService.new
      env_user.admin? ? service.select_sorted_all_options : service.select_active_options
    end

    def current_user_editor(record)
      if record.respond_to?(:current_username)
        User.find_by_username(record.current_username.to_s) if record.current_username.present?
      end
    end

    # This will now check if there is value passed in, since this can be used for optional fields (i.e. other_affiliation)
    # as well as required ones with multiples allowed (i.e. degree_field)
    def validate_other_value_multiple? (record, field: nil, collection: [])
      other_field = "#{field}_other".to_sym
      other_value = record.send(other_field)
      error_counter = 0

      valid_values = []
      if other_value.present?
        other_value.each do |entry|
          if other_value_in_collection? other_value: entry, collection: collection
            err_message = I18n.translate(:"simple_form.actor_validation.other_value_exists", other_entry: entry.to_s)
            add_error_message(record, other_field, err_message)
            record.send(field) << [{option: 'Other', err_msg: err_message, other_entry: entry.to_s}.to_json]
            error_counter += 1
          else
            valid_values << entry.to_s
          end
        end
      else
        if record.attributes[field.to_s].present? && record.attributes[field.to_s].include?('Other')
          err_message = I18n.t('simple_form.actor_validation.other_value_missing')
          add_error_message(record, other_field, err_message)
          record.send(field) << [{option: 'Other', err_msg: err_message}.to_json]
          error_counter += 1
        end
      end

      if error_counter > 0
        valid_values.each do |entry|
          record.send(field) << [{option: 'Other', err_valid_val:true, other_entry: entry.to_s}.to_json]
        end
      end
      error_counter
    end

    def other_value_in_collection? (other_value: nil, collection: [])
      !collection.select { |option| option.include? other_value }.empty? ? true : false
    end

    private

    def add_error_message(record, field, error_msg)
      record.errors[field.to_s] << error_msg
    end
  end
end
