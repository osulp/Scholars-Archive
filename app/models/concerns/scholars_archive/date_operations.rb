module ScholarsArchive
  module DateOperations
    extend ActiveSupport::Concern

    def to_solr(solr_doc={})
      solr_doc = super
      solr_doc = solr_doc.merge({"date_decades_ssim" => decades})
      solr_doc = solr_doc.merge({"date_facet_yearly_ssim" => date_facet_yearly})
      solr_doc
    end

    # date_facet_yearly is intended to be used for date_facet_yearly_ssim, which is used by the facet provided
    # by the interactive Blacklight Range Limit widget
    # date_facet_yearly is expected to return an array of yearly date values like [1910, 1911, 1912]
    # If given date_value = invalid date, i.e. "typo_here2011-12-01", we will get nil
    def date_facet_yearly
      return nil if yearly_dates.empty?
      yearly_dates
    rescue ArgumentError => e
      Rails.logger.warn e.message
      return nil
    end

    # decades is intended to be used for date_decades_ssim, which is used by the decade facet
    # decades is expected to return an array of year ranges like ["1910-1919", "1920-1929"]
    # here are some examples:
    #  a) given date_value = "2017-12-01", we will get ["2010-2019"]
    #  b) given date_value = "2017-12", we will get ["2010-2019"]
    #  c) given date_value = "2017", we will get ["2010-2019"]
    #  d) given date_value = "2017-2018", we will get ["2010-2019"]
    #  e) given date_value = "2010-2020", we will get ["2010-2019", "2020-2029"]
    #  f) given date_value = "1900-1940", we will get nil
    #  g) given date_value = invalid date, i.e. "typo_here2011-12-01", we will get nil
    def decades
      return nil if decade_dates.empty?
      decade_dates.map(&:decade)
    rescue ArgumentError => e
      Rails.logger.warn e.message
      return nil
    end

    # Determine the date value to use for Decades facet and date facet yearly processing.
    def date_value
      if date_created.present? then
        date_created
      elsif date_copyright.present? then
        date_copyright
      elsif date_issued.present? then
        date_issued
      end
    end

    # yearly_dates returns an array of years given a valid date_value. Here are some examples:
    #  a) given date_value = "2017-12-01", we will get [2017]
    #  b) given date_value = "2017-12", we will get [2017]
    #  c) given date_value = "2017", we will get [2017]
    # it also works with ranges and special dates in the ISO 8601 format:
    #  d) given date_value = "2017-12-01/2019-12-01", we will get [2017, 2018, 2019]
    #  e) given date_value = "2017-12/2019-12", we will get [2017, 2018, 2019]
    #  f) given date_value = "2017/2019", we will get [2017, 2018, 2019]
    def yearly_dates
      (date_value) ? clean_years : []
    end

    def clean_years
      date = Date.edtf(date_value)
      if date.instance_of? EDTF::Interval
        date.map(&:year).uniq
      elsif date.instance_of? Date
        Array.wrap(date.year)
      else
        Array.wrap(parsed_year)
      end
    end

    def decade_dates
      dates = DateDecadeConverter.new(date_value).run
      dates ||= Array.wrap(DecadeDecorator.new(parsed_year))
    end

    def parsed_year
      clean_datetime.year
    end

    def clean_datetime
      if date_value =~ /^[0-9]{4}-[0-9]{2}-[0-9]{2}$/ # YYYY-MM-DD
        DateTime.strptime(date_value, "%Y-%m-%d")
      elsif date_value  =~ /^[0-9]{4}-[0-9]{2}$/ # YYYY-MM
        DateTime.strptime(date_value, "%Y-%m")
      elsif date_value =~ /^[0-9]{4}/ # YYYY
        DateTime.strptime(date_value.split("-").first, "%Y")
      else
        raise ArgumentError.new("Invalid date_value. Acceptable formats: YYYY-MM-DD, YYYY-MM, YYYY.")
      end
    end

    class DecadeDecorator
      attr_accessor :year
      def initialize(year)
        @year = year
      end

      def decade
        "#{first_year}-#{last_year}"
      end

      private

      def first_year
        year - year%10
      end

      def last_year
        year + 10 - (year+10)%10 - 1
      end
    end

    # Used for processing decades given a date and generates an array of decorated items using DecadeDecorator
    # when calling run. Expected input dates: "2017-12-01", "2017-12", "2017", "2017-2018", "2010-2020", "1900-1940"
    class DateDecadeConverter
      attr_accessor :date
      def initialize(date)
        @date = date
      end

      def run
        return unless valid_date_range?
        decades.times.map do |decade|
          DecadeDecorator.new(earliest_date + 10*decade)
        end
      end

      private

      def earliest_date
        @earliest_date ||= dates.first - dates.first%10
      end

      def valid_decade_size?
        decades <= 3
      end

      def valid_date_range?
        dates.first.to_s.length == 4 && dates.last.to_s.length == 4 && dates.length == 2
      end

      def dates
        @dates ||= date.to_s.split("-").map(&:to_i)
      end

      def decades
        calculated_decades = (dates.last - dates.first)/10 + 1
        calculated_decades <= 3 ? calculated_decades : 0
      end
    end
  end
end
