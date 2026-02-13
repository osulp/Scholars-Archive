# frozen_string_literal: true

module ScholarsArchive
  # per controller behavior
  module PurchasedEResourceWorksControllerBehavior
    extend ScholarsArchive::WorksControllerBehavior
    extend ActiveSupport::Concern
    include Hyrax::WorksControllerBehavior

    after_action :email_for_accessibility_attestation, only: %i[create]

    def new
      curation_concern.rights_statement = ['http://rightsstatements.org/vocab/InC/1.0/']
      super
    end

    private

    def email_for_accessibility_attestation
      return unless params[hash_key_for_curation_concern]['attest'] == 'false'

      ScholarsArchive::AttestationMailer.accessibility_attestation_mail(current_user.email, curation_concern).deliver_now
      ScholarsArchive::UserAttestationMailer.user_attestation_mail(current_user.email).deliver_now
    end
  end
end
