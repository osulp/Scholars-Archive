# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work PurchasedEResource`

module Hyrax
  # per controller
  class PurchasedEResourcesController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include ScholarsArchive::PurchasedEResourceWorksControllerBehavior
    include ScholarsArchive::RedirectIfRestrictedBehavior
    include Hyrax::BreadcrumbsForWorks
    include ScholarsArchive::BotDetectionBehavior

    # Redirect for Bot Detection
    before_action except: :oai do |controller|
      BotDetectionController.bot_detection_enforce_filter(controller) unless valid_bot?
    end
    # Allow upstream caching of pages
    before_action :allow_page_caching

    after_action :email_for_accessibility_attestation, only: %i[create]

    self.curation_concern_type = ::PurchasedEResource
    self.show_presenter = PurchasedEResourcePresenter

    before_action :ensure_admin!, only: :destroy

    private

    def ensure_admin!
      authorize! :read, :admin_dashboard
    end

    def email_for_accessibility_attestation
      return unless params[hash_key_for_curation_concern]['attest'] == 'false'

      ScholarsArchive::AttestationMailer.accessibility_attestation_mail(current_user.email, curation_concern).deliver_now
      ScholarsArchive::UserAttestationMailer.user_attestation_mail(current_user.email).deliver_now
    end
  end
end
