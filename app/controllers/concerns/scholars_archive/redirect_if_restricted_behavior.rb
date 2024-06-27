# frozen_string_literal:true

module ScholarsArchive
  # Redirect if a work is under embargo
  module RedirectIfRestrictedBehavior
    extend ActiveSupport::Concern

    included do
      before_action :redirect_if_restricted, only: :show

      # rubocop:disable Metrics/CyclomaticComplexity
      # rubocop:disable Metrics/MethodLength
      # rubocop:disable Metrics/PerceivedComplexity
      def redirect_if_restricted
        curation_concern = ActiveFedora::Base.find(params[:id])

        # If we are approving and it is not readable by the current user
        if cannot?(:edit, curation_concern) && (curation_concern.to_solr['workflow_state_name_ssim'] == 'Changes Required')
          flash[:notice] = "The work is not currently available because it has not completed the approval process. If you are the owner of this work, #{helpers.link_to 'Click here', request.original_url} to login and continue."
          redirect_to '/'
        end

        # Reset flash notice since we redirected due to not viewable
        flash[:alert] = ''

        # First we check if the user can see the work or fileset
        return unless cannot?(:read, curation_concern) && (curation_concern.embargo_id.present? || curation_concern.visibility == 'authenticated')

        # Next we check if user got here specifically from the homepage. This means they got redirected and clicked the login link.
        return if request.referrer.to_s == "https://#{ENV.fetch('SCHOLARSARCHIVE_URL_HOST')}/"

        # Otherwise, this returns them to the homepage because they got here from elsewhere and need to know this work is embargoed
        # and if its OSU visible, provided a link to login and continue to where they were going
        if curation_concern.embargo_id.present?
          case curation_concern.embargo.visibility_during_embargo
          when 'restricted'
            flash[:notice] = "The item you are trying to access is under embargo until #{curation_concern.embargo.embargo_release_date.strftime('%B')} #{curation_concern.embargo.embargo_release_date.day}, #{curation_concern.embargo.embargo_release_date.year}."
          when 'authenticated'
            flash[:notice] = "The item you are trying to access is under embargo until #{curation_concern.embargo.embargo_release_date.strftime('%B')} #{curation_concern.embargo.embargo_release_date.day}, #{curation_concern.embargo.embargo_release_date.year}. However, users with an OSU login (ONID) may log in to view the item. #{helpers.link_to 'Click here to login and continue to your work', request.original_url}"
          end
        else
          flash[:notice] = "The item you are trying to access is limited to OSU users only. Users with an OSU login (ONID) may log in to view the item. #{helpers.link_to 'Click here to login and continue to your work', request.original_url}"
        end
        redirect_to '/'
      end
      # rubocop:enable Metrics/CyclomaticComplexity
      # rubocop:enable Metrics/MethodLength
      # rubocop:enable Metrics/PerceivedComplexity
    end
  end
end
