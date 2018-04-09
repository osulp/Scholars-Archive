module ScholarsArchive::Validators
  class OtherOptionDegreeValidator < ActiveModel::Validator

    def degree_present? (record)
      record.respond_to?(:degree_field) && record.respond_to?(:degree_level) && record.respond_to?(:degree_name)
    end

    def degree_grantors_present? (record)
      record.respond_to?(:degree_grantors) && record.degree_grantors.present? && record.respond_to?(:degree_grantors_other)
    end

    def validate(record)
      error_counter = 0

      if degree_present? (record)
        # check if degree_level_other is already in the list or is missing
        error_counter += validate_other_value? record, field: :degree_level, collection: degree_level_options(current_user_editor(record))

        # check if degree_field_other is already in the list or is missing
        error_counter += validate_other_value_multiple? record, field: :degree_field, collection: degree_field_options(current_user_editor(record))

        # check if degree_name_other is already in the list or is missing
        error_counter += validate_other_value_multiple? record, field: :degree_name, collection: degree_name_options(current_user_editor(record))

      end

      if degree_grantors_present? (record)
        # check if degree_grantors_other is already in the list or is missing
        error_counter += validate_other_value? record, field: :degree_grantors, collection: degree_grantors_options(record.degree_grantors, current_user_editor(record))
      end

      return
    end

    def current_user_editor(record)
      if record.respond_to?(:current_username)
        User.find_by_username(record.current_username.to_s) if record.current_username.present?
      end
    end

    def degree_field_options(env_user)
      service = ScholarsArchive::DegreeFieldService.new
      env_user.present? && env_user.admin? ? service.select_sorted_all_options_truncated : service.select_sorted_current_options_truncated
    end

    def degree_level_options(env_user)
      service = ScholarsArchive::DegreeLevelService.new
      env_user.present? && env_user.admin? ? service.select_sorted_all_options : service.select_active_options
    end

    def degree_name_options(env_user)
      service = ScholarsArchive::DegreeNameService.new
      env_user.present? && env_user.admin? ? service.select_sorted_all_options : service.select_active_options
    end

    def degree_grantors_options(value, env_user)
      service = ScholarsArchive::DegreeGrantorsService.new
      service.select_sorted_all_options(value, env_user.present? ? env_user.admin? : false)
    end

    def validate_other_value? (record, field: nil, collection: [])
      other_field = "#{field}_other".to_sym
      other_value = record.send(other_field)
      error_counter = 0
      if other_value.present?
        if other_value_in_collection? other_value: other_value, collection: collection
          add_error_message(record, other_field, I18n.translate(:"simple_form.actor_validation.other_value_exists", other_entry: other_value.to_s))
          error_counter += 1
        end
      else
        if record.attributes[field.to_s] == 'Other'
          add_error_message(record, other_field, I18n.t("simple_form.actor_validation.other_value_missing"))
          error_counter += 1
        end
      end
      return error_counter
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
            record.send(field) << [{option: "Other", err_msg: err_message, other_entry: entry.to_s}.to_json]
            error_counter += 1
          else
            valid_values << entry.to_s
          end
        end
      else
        if record.attributes[field.to_s].present? && record.attributes[field.to_s].include?('Other')
          err_message = I18n.t("simple_form.actor_validation.other_value_missing")
          add_error_message(record, other_field, err_message)
          record.send(field) << [{option: "Other", err_msg: err_message}.to_json]
          error_counter += 1
        end
      end

      if error_counter > 0
        valid_values.each do |entry|
          record.send(field) << [{option: "Other", err_valid_val:true, other_entry: entry.to_s}.to_json]
        end
      end
      return error_counter
    end

    def other_value_in_collection? (other_value: nil, collection: [])
      !collection.select {|option| option.include? other_value}.empty? ? true : false
    end

    private

    def add_error_message(record, field, error_msg)
      record.errors[field.to_s] << error_msg
    end
  end
end
