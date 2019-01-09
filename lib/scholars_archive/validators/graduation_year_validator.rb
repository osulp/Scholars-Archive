# frozen_string_literal: true

module ScholarsArchive::Validators
  class GraduationYearValidator < ActiveModel::Validator
    def validate(record)
      return if !record.graduation_year.present? || valid_value(record)
      add_error_message(record)
      return
    end

    private

    def valid_value(record)
      grad_year = DateTime.strptime(record.graduation_year.to_i.to_s, '%Y').year
      valid_date_string(record.graduation_year) && valid_date_range(grad_year)
    end

    def valid_date_string(date)
      return true if date.length == 4
      false
    end

    def valid_date_range(grad_year)
      return true if grad_year >= 1868 && grad_year <= (Date.today.year + 5)
      false
    end

    def add_error_message(record)
      record.errors['graduation_year'] << I18n.t('hyrax.errors.graduation_year_error')
    end
  end
end
