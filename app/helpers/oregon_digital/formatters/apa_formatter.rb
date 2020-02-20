# frozen_string_literal: true

module OregonDigital
  module CitationsBehaviors
    module Formatters
      # OVERRIDES SETUP PUB DATE TO USE DATE ISSUED
      class ApaFormatter < Hyrax::CitationsBehaviors::Formatters::ApaFormatter
        def setup_pub_date(work)
          # OVERRIDE HERE
          first_date = work.solr_document.date_issued.first if work.solr_document.date_issued
          # END OVERRIDE
          if first_date.present?
            first_date = CGI.escapeHTML(first_date)
            date_value = first_date.gsub(/[^0-9|n\.d\.]/, '')[0, 4]
            return nil if date_value.nil?
          end
          clean_end_punctuation(date_value) if date_value
        end
      end
    end
  end
end
