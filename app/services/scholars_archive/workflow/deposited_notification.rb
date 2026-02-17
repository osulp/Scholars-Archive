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
        workflow_state = entity.workflow_state.name
        if (workflow_state == 'Graduate School Review') || (workflow_state == 'Honors College Review')
          'ScholarsArchive@OSU Message: Deposit advanced!'
        else
          'ScholarsArchive@OSU Message: Deposit approved!'
        end
      end

      # rubocop:disable Metrics/MethodLength
      # rubocop:disable Metrics/CyclomaticComplexity
      # rubocop:disable Metrics/PerceivedComplexity
      def message
        if SolrDocument.find(work_id)['resource_type_tesim']&.include?('Honors College Thesis') || SolrDocument.find(work_id)['resource_type_tesim']&.include?('Dissertation') || SolrDocument.find(work_id)['resource_type_tesim']&.include?('Masters Thesis')
          workflow_state = entity.workflow_state.name
          if (workflow_state == 'Graduate School Review') || (workflow_state == 'Honors College Review')
            "Your deposit: '#{title}' #{@doi} (#{link_to work_id, citeable_url}) was approved by #{user.user_key}. It is now live in ScholarsArchive@OSU review queue for a metadata check. You will get a message when it is live in the repository. <br/><br/>
            #{comment} <br/><br/>
            Thank you, <br/>
            ScholarsArchive@OSU Admin <br/>
            Oregon State University Libraries and Press"
          else
            "Your deposit: '#{title}' #{@doi} (#{link_to work_id, citeable_url}) was approved by #{user.user_key} and is now live in ScholarsArchive@OSU. <br/><br/>
            #{comment} <br/><br/>
            Citeable URL: #{citeable_url} <br/><br/>
            Your document has been converted to PDF format by repository administrators. Please review the final PDF version to ensure it appears as intended. If conversion errors are noted, contact #{link_to 'ScholarsArchive@oregonstate.edu', 'mailto:scholarsarchive@oregonstate.edu'} to request changes. <br/><br/>
            Thank you, <br/>
            ScholarsArchive@OSU Admin <br/>
            Oregon State University Libraries and Press"
          end
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
      # rubocop:enable Metrics/CyclomaticComplexity
      # rubocop:enable Metrics/PerceivedComplexity

      def users_to_notify
        user_key = ActiveFedora::Base.find(work_id).depositor
        [::User.find_by(username: user_key)]
      end
    end
  end
end
