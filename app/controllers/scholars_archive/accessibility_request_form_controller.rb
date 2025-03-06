# frozen_string_literal: true

module ScholarsArchive
  # CLASS: Accessibility Request Form Controller
  class AccessibilityRequestFormController < ApplicationController
    # ACTION: Before page load, build the form with all the params
    include ScholarsArchive::AccessibilityRequestFormRecaptchaBehavior
    before_action :build_accessibility_request_form
    invisible_captcha only: [:create]
    layout 'homepage'

    def new
      @request_url = session[:request_url]
    end

    # rubocop:disable Metrics/MethodLength
    def create
      # SAVE: Preserve the URL in the session before any validations
      @save_url = @accessibility_form.url_link unless @accessibility_form.url_link.blank?

      # CHECK: Make sure email matches before submission
      if @accessibility_form.email != @accessibility_form.confirm_email
        flash.now[:error] = t('hyrax.accessibility_request_form.mismatch_email')
        @accessibility_form = ScholarsArchive::AccessibilityRequestForm.new
        @accessibility_form.url_link = @save_url

        # RENDER: Render the form again with the stored URL
        render :new and return
      end

      # CHECK: See if the form is valid
      if @accessibility_form.valid?
        # IF: If recaptcha present, then send the email and reload the new form for submission
        if check_recaptcha
          ScholarsArchive::AccessibilityFormMailer.auto_contact(@accessibility_form).deliver_now
          ScholarsArchive::AccessibilityFormMailer.admin_contact(@accessibility_form).deliver_now
          flash.now[:notice] = t('hyrax.accessibility_request_form.success_email')
          after_deliver
          @accessibility_form = ScholarsArchive::AccessibilityRequestForm.new
          @accessibility_form.url_link = @save_url
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
      @accessibility_form = ScholarsArchive::AccessibilityRequestForm.new(accessibility_request_form_params)
    end

    # METHOD: Permits all the required params
    def accessibility_request_form_params
      return {} unless params.key?(:scholars_archive_accessibility_request_form)

      params.require(:scholars_archive_accessibility_request_form).permit(:accessibility_method, :email, :confirm_email, :name, :url_link, :details, :additional, :phone, :date)
    end
  end
end
