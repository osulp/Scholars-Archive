module ScholarsArchive::Validators
  class GraduationYearLengthValidator < ActiveModel::Validator
    def validate(record)
      return if record.graduation_year.empty?
      begin
        Datetime.strptime(record.graduation_year, "%Y").year
      rescue
        add_error_message(record)
      end
    end

    private

    def add_error_message(record)
      record.errors["graduation_year"] << t("hyrax.errors.graduation_year_error")
    end
  end
end
