# frozen_string_literal: true

module ScholarsArchive
  # CLASS: Accessibility Request Form Model
  class AccessibilityRequestForm
    include ActiveModel::Model
    # ADD: Add in accessors to map out on field that will be use in the form
    attr_accessor :accessibility_method, :email, :confirm_email, :name, :url_link, :details, :additional, :phone, :date

    # VALIDATION: Add in validation to these variables to check before pass the form
    validates :email, :confirm_email, :name, :url_link, :details, presence: true
    validates :email, format: /\A([\w.%+-]+)@([\w-]+\.)+(\w{2,})\z/i, allow_blank: true
    validates :confirm_email, format: /\A([\w.%+-]+)@([\w-]+\.)+(\w{2,})\z/i, allow_blank: true

    # SPAM: Check to make sure this section isn't fill, if so, it might be a spam
    def spam?
      accessibility_method.present?
    end

    # HEADER: Declare the e-mail headers. It accepts anything the mail method in ActionMailer accepts
    def headers
      {
        subject: 'Scholars Archive Accessibility Request Form: Request on Work',
        to: Hyrax.config.contact_email,
        from: email
      }
    end

    # HEADER: Declare the e-mail headers. It accepts anything the mail method in ActionMailer accepts
    def auto_headers
      {
        subject: 'Scholars Archive Accessibility Request Form: Request Confirmation',
        to: email,
        from: Hyrax.config.contact_email
      }
    end
  end
end
