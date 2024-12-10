# frozen_string_literal: true

module ScholarsArchive
  # CLASS: Accessibility Form Mailer for contacting the administrator & depositor request
  class AccessibilityFormMailer < ApplicationMailer
    # METHOD: A method to send an auto confirmation email
    def auto_contact(accessibility_form)
      @accessibility_form = accessibility_form
      # Check for spam
      return if @accessibility_form.spam?

      mail(@accessibility_form.auto_headers)
    end
  end
end
