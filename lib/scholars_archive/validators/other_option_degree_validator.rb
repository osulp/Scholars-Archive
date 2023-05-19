# frozen_string_literal: true

module ScholarsArchive::Validators
  # other degree validation
  class OtherOptionDegreeValidator < ActiveModel::Validator
    def degree_present?(record)
      record.respond_to?(:degree_field) && record.respond_to?(:degree_level) && record.respond_to?(:degree_name)
    end

    def degree_grantors_present?(record)
      record.respond_to?(:degree_grantors) && record.degree_grantors.present? && record.respond_to?(:degree_grantors_other)
    end

    def validate(_record)
      # error_counter = 0

      # if degree_present? (record)
      # check if degree_level_other is already in the list or is missing
      # error_counter += ScholarsArchive::FieldValidationService.validate_other_value? record,
      #                                                                                 field: :degree_level,
      #                                                                                 env_user: current_user_editor(record)

      # check if degree_field_other is already in the list or is missing
      # error_counter += ScholarsArchive::FieldValidationService.validate_other_value_multiple? record,
      #                                                                                          field: :degree_field,
      #                                                                                          env_user: current_user_editor(record)

      # check if degree_name_other is already in the list or is missing
      # error_counter += ScholarsArchive::FieldValidationService.validate_other_value_multiple? record,
      #                                                                                          field: :degree_name,
      #                                                                                          env_user: current_user_editor(record)
      # end

      # if degree_grantors_present? (record)
      # check if degree_grantors_other is already in the list or is missing
      #  error_counter += ScholarsArchive::FieldValidationService.validate_other_value? record,
      #                                                                                 field: :degree_grantors,
      #                                                                                 env_user: current_user_editor(record)
      # end

      nil
    end

    def current_user_editor(record)
      if record.respond_to?(:current_username)
        User.find_by_username(record.current_username.to_s) if record.current_username.present?
      end
    end
  end
end
