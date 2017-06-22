module ScholarsArchive
  module DateOperations
    extend ActiveSupport::Concern

    def to_solr(solr_doc={})
      solr_doc = super
      solr_doc = solr_doc.merge({"date_decades_ssim" => decades})
      solr_doc = solr_doc.merge({"date_facet_yearly_ssim" => date_facet_yearly})
      solr_doc
    end

    def date_facet_yearly
      return nil if yearly_dates.empty?
      yearly_dates
    rescue ArgumentError
    end

    def decades
      return nil if decade_dates.empty?
      decade_dates.map(&:decade)
    rescue ArgumentError
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
        Array.wrap(clean_datetime.year)
      end
    end

    def decade_dates
      dates = DateDecadeConverter.new(date_value).run
      dates ||= Array.wrap(DecadeDecorator.new(clean_datetime.year))
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
        if calculated_decades <= 3
          calculated_decades
        else
          0
        end
      end

      def calculated_decades
        (dates.last-dates.first)/10 + 1
      end

    end

    def clean_datetime
      if date_value =~ /^[0-9]{4}-[0-9]{2}-[0-9]{2}$/ # YYYY-MM-DD
        DateTime.strptime(date_value, "%Y-%m-%d")
      elsif date_value  =~ /^[0-9]{4}-[0-9]{2}$/ # YYYY-MM
        DateTime.strptime(date_value, "%Y-%m")
      elsif date_value =~ /^[0-9]{4}/ # YYYY
        DateTime.strptime(date_value.split("-").first, "%Y")
      else
        raise ArgumentError
      end
    end

  end
end
