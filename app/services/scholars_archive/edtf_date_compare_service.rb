module ScholarsArchive
  class EdtfDateCompareService
    def self.includes_last_five_years?(active_option)
      last_five_years_include?(active_option)
    end

    private

      #This method normalizes the active_option sent into this method. If the
      #date comes not in the form {date1, date2, date..range} it will coerce it
      #into that form so Date.edtf will be able to parse it. active_option is in
      #the form ["Label - date", "uri"] it will then check if the dates are
      #coming in as date1/date2 and or {date1..date2} and parse accordingly
      def self.last_five_years_include?(active_option)
        academic_date = active_option.first.split(" - ").last
        normalized_date = "{" + academic_date + "}" unless academic_date.include?("{")
        return parse_academic_affiliation(normalized_date) unless normalized_date.nil? || !normalized_date.include?("/")
        date_in_past_five_years?(normalized_date, academic_date) if !academic_date.include?("/")
      end

      def self.parse_academic_affiliation(normalized_date)
        normalized_date.gsub!("/", "..")
        return true if normalized_date.include?("open")
        date_in_past_five_years?(normalized_date, nil)
      end

      def self.date_in_past_five_years?(normalized_date, academic_date)
        last_five_years.map do |date|
          Date.edtf(normalized_date || academic_date).include?(Date.edtf(date.year.to_s))
        end.include?(true)
      end

      def self.last_five_years
        Date.edtf("{" + (Date.today - 5.years).year.to_s + ".." + Date.today.year.to_s + "}")
      end
  end
end
