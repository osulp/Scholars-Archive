# frozen_string_literal: true

module ScholarsArchive
  # Class to handle the expected format for citation publication dates as
  # required in the indexing guidelines for configuring meta-tags:
  # https://scholar.google.com/intl/en/scholar/inclusion.html#indexing
  class GoogleScholarCitationService
    attr_reader :input_date

    def self.call(input_date)
      new(input_date).format_date
    end

    private

    def initialize(input_date)
      @edtf_value = edtf_date(input_date)
    end

    def edtf_date(date)
      edtf_val = Date.edtf(date)
      if edtf_val.blank? && date.present?
        # date_uploaded usually comes in the form m/d/Y unlike edtf that comes in the form Y-m-d
        custom_date = Date.strptime(date, '%m/%d/%Y')
        edtf_val = Date.edtf(custom_date.to_s)
      end
      edtf_val
    rescue StandardError => e
      Rails.logger.warn "GoogleScholarCitationService #{e.message}"
      nil
    end

    def format_date
      if @edtf_value.instance_of? EDTF::Interval
        @edtf_value.to_s
      elsif @edtf_value.present?
        date_from_edtf(@edtf_value)
      else
        @edtf_value.to_s
      end
    end

    def date_from_edtf(date)
      case date
      when year_precision
        date.year.to_s
      when month_precision
        date.try(:strftime, '%Y/%m')
      when day_precision
        date.try(:strftime, '%Y/%m/%d')
      else
        date.to_s
      end
    end

    def month_precision
      proc(&:month_precision?)
    end

    def day_precision
      proc(&:day_precision?)
    end

    def year_precision
      proc(&:year_precision?)
    end
  end
end
