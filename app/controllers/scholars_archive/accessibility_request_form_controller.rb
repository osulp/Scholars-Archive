# frozen_string_literal: true

module ScholarsArchive
  # CLASS: Accessibility Request Form Controller
  class AccessibilityRequestFormController < ApplicationController
    # ACTION: Before page load, build the form with all the params
    include ScholarsArchive::AccessibilityRequestFormRecaptchaBehavior
    before_action :build_accessibility_request_form
    invisible_captcha only: [:create]
    layout 'homepage'

    def new; end

    # rubocop:disable Metrics/MethodLength
    def create
      # CHECK: See if the form is valid
      if @accessibility_request_form.valid?
        # IF: If recaptcha present, then send the email and reload the new form for submission
        if check_recaptcha
          # ScholarsArchive::AccessibilityRequestForm.torrent_contact(@torrent_form).deliver_now
          flash.now[:notice] = t('hyrax.accessibility_request_form.success_email')
          after_deliver
          @accessibility_request_form = ScholarsArchive::AccessibilityRequestForm.new
        end
      else
        flash.now[:error] = t('hyrax.accessibility_request_form.failed_email')
      end
      render :new
    rescue RuntimeError => e
      handle_create_exception(e)
    end
    # rubocop:enable Metrics/MethodLength

    # METHOD: Create a handler for the exception
    def handle_create_exception(exception)
      logger.error("Contact form failed to send: #{exception.inspect}")
      flash.now[:error] = 'Sorry, this message was not delivered.'
      render :new
    end

    # NOTE: Override if needed to perform after email delivery
    def after_deliver; end

    private

    # METHOD: Create a new form with all the params
    def build_accessibility_request_form
      @accessibility_request_form = ScholarsArchive::AccessibilityRequestForm.new(accessibility_request_form_params)
    end

    # METHOD: Permits all the required params
    def accessibility_request_form_params
      return {} unless params.key?(:accessibility_request_form)

      params.require(:accessibility_request_form).permit(:accessibility_request_method, :email, :name, :phone, :url_link, :request_detail, :additional_detail, :date)
    end
  end
end
