# frozen_string_literal: true

module ScholarsArchive
  module Workflow
    # Received deposit
    class DepositReceivedNotification < ScholarsArchive::Workflow::AbstractNotification
      private

      def subject
        'Thank you for your deposit to ScholarsArchive@OSU'
      end

      def doi
        s = SolrDocument.find(work_id) 
        return "https://doi.org/10.7267/#{s.id.to_s}" if s.doi.include?("mint-doi")
        
        return s.doi.first
      end

      # rubocop:disable Metrics/MethodLength
      def message
        if SolrDocument.find(work_id)['resource_type_tesim']&.include?('Article')
          "ScholarsArchive@OSU has received your deposit: #{title}
           <br />
           The citable URL for your article is: #{link_to citeable_url, citeable_url}
           <br /><br/>
           If you have questions, please respond to this email.
           <br/>
           Thank you,
           <br />
           ScholarsArchive@OSU Admin"
        elsif !SolrDocument.find(work_id)['resource_type_tesim']&.include?('Dataset')
          "ScholarsArchive@OSU has received your deposit: #{title} (#{link_to work_id, citeable_url}). Your item is under review by repository administrators. You will be notified if your deposit requires additional changes and/or when your deposit is live in the repository. \n\n #{comment}"
        else
          "ScholarsArchive@OSU has received your deposit: #{title} (#{link_to work_id, citeable_url}). Your DOI is: #{doi}} Your item is under review by repository administrators. You will be notified if your deposit requires additional changes and/or when your deposit is live in the repository.<br />
           <br />
           Reviews typically take several days. If you have a deadline that we should know of please send a message to researchdataservices@oregonstate.edu.<br />
           <br />
           Your temporary DOI is https://doi.org/10.7267/#{work_id} . This DOI will not be live until the dataset is approved, but it won't change.<br>
           <br />
           If the submitted dataset includes human subjects data, give the following information to the data curator:
           <br />
           * A copy of the IRB approval.
           <br />
           * A copy of the application or protocol.
           <br />
           * A copy of the consent document, if any.
           <br />
           * If the protocol and/or consent document says that the data shared will be de-identified, then there should be less than 3 indirect identifiers in the data files.
           <br />
           Visit https://ir.library.oregonstate.edu/ and go to your dashboard for more info."
        end
      end

      # rubocop:enable Metrics/AbcSize
      # rubocop:enable Metrics/MethodLength
      # Add the user who initiated this action to the list of users being notified
      def users_to_notify
        [user]
      end
    end
  end
end
