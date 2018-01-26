module ScholarsArchive::Validators
  class GraduationYearLengthValidator < ActiveModel::Validator
    def validate(record)
      return if record.graduation_year.empty?
      if record.graduation_year.length != 4
        record.errors["graduation_year"] << "Please ensure you a year is used in this field (e.g 1901)"
      end
    end
  end
end
