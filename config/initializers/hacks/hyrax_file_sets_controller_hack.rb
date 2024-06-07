# frozen_string_literal:true

Rails.application.config.to_prepare do
  Hyrax::FileSetsController.class_eval do
    # INCLUDE: Add in the redirect to filesets for embargo
    include ScholarsArchive::RedirectIfRestrictedBehavior

    def show
      curation_concern = presenter.solr_document.id

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
      # Prevent fileset page from displaying if parent work is still in workflow
      if presenter.parent.solr_document.suppressed? && !current_user&.admin?
        flash[:notice] = "The item you tried to access is unavailable because it is in the review process."
        redirect_to '/'
        return if presenter.parent.solr_document.suppressed?
      end
      # Original Hyrax response
      respond_to do |wants|
        wants.html { presenter }
        wants.json { presenter }
        additional_response_formats(wants)
      end
    end
  end
end
