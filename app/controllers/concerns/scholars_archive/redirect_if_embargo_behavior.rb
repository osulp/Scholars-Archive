# frozen_string_literal:true

module ScholarsArchive
	module RedirectIfEmbargoBehavior
    extend ActiveSupport::Concern
		
		included do
    	before_action :redirect_if_embargo, only: :show

			def redirect_if_embargo
   	    curation_concern = ActiveFedora::Base.find(params[:id])
        # First we check if the user can see the work
        return unless cannot?(:read, curation_concern) && curation_concern.embargo_id.present?

        # Next we check if user got here specifically from the homepage. This means they got redirected and clicked the login link.
        return if request.original_url == 'http://ir.library.oregonstate.edu/'

        # Otherwise, this returns them to the homepage because they got here from elsewhere and need to know this work is embargoed
        # and if its OSU visible, provided a link to login and continue to where they were going
        case curation_concern.embargo.visibility_during_embargo
        when 'restricted'
          flash[:notice] = "The item you are trying to access is under embargo until #{curation_concern.embargo.embargo_release_date.month.strftime('%B')} #{curation_concern.embargo.embargo_release_date.day}, #{curation_concern.embargo.embargo_release_date.year}."
        when 'authenticated'
          flash[:notice] = "The item you are trying to access is under embargo until #{curation_concern.embargo.embargo_release_date.month.strftime('%B')} #{curation_concern.embargo.embargo_release_date.day}, #{curation_concern.embargo.embargo_release_date.year}. However, users with an OSU login (ONID) may log in to view the item. #{helpers.link_to 'Click here to login and continue to your work', request.original_url}"
        end

        redirect_to '/'
      end
		end
	end
end
