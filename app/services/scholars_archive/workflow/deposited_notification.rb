# frozen_string_literal: true

module ScholarsArchive
  module Workflow
    # Deposit notification
    class DepositedNotification < ScholarsArchive::Workflow::AbstractNotification
      def initialize(entity, comment, user, recipients)
        @doi = entity.proxy_for.doi
        super(entity, comment, user, recipients)
      end

      private

      def subject
        'ScholarsArchive@OSU Message: Deposit approved!'
      end

      # rubocop:disable Metrics/MethodLength
      def message
        if SolrDocument.find(work_id)['resource_type_tesim']&.include?('Honors College Thesis') || SolrDocument.find(work_id)['resource_type_tesim']&.include?('Dissertation') || SolrDocument.find(work_id)['resource_type_tesim']&.include?('Masters Thesis')
          "Your deposit: '#{title}' #{@doi} (#{link_to work_id, citeable_url}) was approved by #{user.user_key} and is now live in ScholarsArchive@OSU. <br/><br/>
          #{comment} <br/><br/>
          Citeable URL: #{citeable_url} <br/><br/>
          Your document has been converted to PDF format by repository administrators. Please review the final PDF version to ensure it appears as intended. If conversion errors are noted, contact #{link_to 'ScholarsArchive@oregonstate.edu', 'mailto:scholarsarchive@oregonstate.edu'} to request changes. <br/><br/>
          Thank you, <br/>
          ScholarsArchive@OSU Admin <br/>
          Oregon State University Libraries and Press"
        else
          "Your deposit: '#{title}' #{@doi} (#{link_to work_id, citeable_url}) was approved by #{user.user_key} and is now live in ScholarsArchive@OSU. <br/><br/>
          #{comment} <br/><br/>
          Citeable URL: #{citeable_url} <br/><br/>
          If you have questions, please reply to this message or contact #{link_to 'ScholarsArchive@oregonstate.edu', 'mailto:scholarsarchive@oregonstate.edu'}. <br/><br/>
          Thank you, <br/>
          ScholarsArchive@OSU Admin <br/>
          Oregon State University Libraries and Press"
        end
      end
      # rubocop:enable Metrics/MethodLength

      def users_to_notify
        user_key = ActiveFedora::Base.find(work_id).depositor
        [::User.find_by(username: user_key)]
      end
    end
  end
end
