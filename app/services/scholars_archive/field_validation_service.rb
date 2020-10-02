# frozen_string_literal: true

module ScholarsArchive
  # Validates fields
  class FieldValidationService
    def self.degree_field_options(env_user)
      service = ScholarsArchive::DegreeFieldService.new
      env_user.present? && env_user.admin? ? service.select_sorted_all_options_truncated : service.select_sorted_current_options_truncated
    end

    def self.degree_level_options(env_user)
      service = ScholarsArchive::DegreeLevelService.new
      env_user.present? && env_user.admin? ? service.select_sorted_all_options : service.select_active_options
    end

    def self.degree_name_options(env_user)
      service = ScholarsArchive::DegreeNameService.new
      env_user.present? && env_user.admin? ? service.select_sorted_all_options : service.select_active_options
    end

    def self.degree_grantors_options(value, env_user)
      service = ScholarsArchive::DegreeGrantorsService.new
      service.select_sorted_all_options(value, env_user.present? ? env_user.admin? : false)
    end

    def self.get_collection(field, record: nil, env_user: nil)
      if field.to_s == 'degree_level'
        degree_level_options(env_user)
      elsif field.to_s == 'degree_grantors'
        degree_grantors_options(record.degree_grantors, env_user)
      elsif field.to_s == 'degree_name'
        degree_name_options(env_user)
      elsif field.to_s == 'degree_field'
        degree_field_options(env_user)
      else
        []
      end
    end

    def self.validate_other_value? (record, field: nil, env_user: nil)
      other_field = "#{field}_other".to_sym
      other_value = record.send(other_field)
      error_counter = 0
      collection = get_collection(field, record: record, env_user: env_user)
      if other_value.present?
        if other_value_in_collection? other_value: other_value, collection: collection
          add_error_message(record, other_field, I18n.translate(:"simple_form.actor_validation.other_value_exists", other_entry: other_value.to_s))
          error_counter += 1
        end
      else
        # NOTE: For some reason the code bellow causes CreateDerivativesJob to fail with "NoMethodError: undefined
        # method title for nil:NilClass" as reported in https://github.com/osulp/Scholars-Archive/issues/1383
        #
        # TODO: For now, I think we should only do validation with JS until we figure out a better way
        # to handle server side validation for custom 'Other' options when they are missing or blank.
        #
        # if record.class.ancestors.include?(::ScholarsArchive::EtdMetadata) && record.attributes[field.to_s] == 'Other'
        #   add_error_message(record, other_field, I18n.t("simple_form.actor_validation.other_value_missing"))
        #   error_counter += 1
        # end
      end
      error_counter
    end

    def self.is_valid_other_field?(record, field: nil, env_user: nil)
      other_field = "#{field}_other".to_sym
      other_value = record.send(other_field)
      error_counter = 0
      collection = get_collection(field, record: record, env_user: env_user)
      if other_value.present?
        error_counter += 1 if other_value_in_collection? other_value: other_value, collection: collection
      else
        error_counter += 1 if record.class.ancestors.include?(::ScholarsArchive::EtdMetadata) && record.attributes[field.to_s] == 'Other'
      end
      (error_counter > 0) ? false : true
    end

    def self.is_valid_other_field_multiple? (record, env_attributes: nil, field: nil, env_user: nil)
      other_field = "#{field}_other".to_sym
      other_value = env_attributes[other_field.to_s]
      error_counter = 0
      collection = get_collection(field, record: record, env_user: env_user)

      if other_value.present?
        other_value.each do |entry|
          error_counter += 1 if other_value_in_collection? other_value: entry, collection: collection
        end
      else
        error_counter += 1 if record.class.ancestors.include?(::ScholarsArchive::EtdMetadata) && record.attributes[field.to_s].present? && record.attributes[field.to_s].include?('Other')
      end
      (error_counter > 0) ? false : true
    end

    # This will now check if there is value passed in, since this can be used for optional fields (i.e. other_affiliation)
    # as well as required ones with multiples allowed (i.e. degree_field)
    def self.validate_other_value_multiple? (record, field: nil, env_user: nil)
      other_field = "#{field}_other".to_sym
      other_value = record.send(other_field)
      error_counter = 0
      collection = get_collection(field, record: record, env_user: env_user)

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
        # NOTE: For some reason the code bellow also causes CreateDerivativesJob to fail with "NoMethodError: undefined
        # method title for nil:NilClass" as reported in https://github.com/osulp/Scholars-Archive/issues/1383
        #
        # TODO: For now, I think we should only do validation with JS until we figure out a better way
        # to handle server side validation for custom 'Other' options when they are missing or blank.
        #
        # if record.class.ancestors.include?(::ScholarsArchive::EtdMetadata) && record.attributes[field.to_s].present? && record.attributes[field.to_s].include?('Other')
        #   err_message = I18n.t("simple_form.actor_validation.other_value_missing")
        #   add_error_message(record, field, err_message)
        #   record.send(field) << [{option: "Other", err_msg: err_message}.to_json]
        #   error_counter += 1
        # end
      end

      if error_counter > 0
        valid_values.each do |entry|
          record.send(field) << [{option: 'Other', err_valid_val:true, other_entry: entry.to_s}.to_json]
        end
      end
      error_counter
    end

    def self.other_value_in_collection? (other_value: nil, collection: [])
      !collection.select { |option| option.include? other_value }.empty? ? true : false
    end

    private

    def self.add_error_message(record, field, error_msg)
      record.errors[field.to_s] << error_msg
    end
  end
end
