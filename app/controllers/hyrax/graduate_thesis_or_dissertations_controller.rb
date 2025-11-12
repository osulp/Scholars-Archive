# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work GraduateThesisOrDissertation`

module Hyrax
  # grad thesis or dissertation controller
  class GraduateThesisOrDissertationsController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include ScholarsArchive::WorksControllerBehavior
    include ScholarsArchive::RedirectIfRestrictedBehavior
    include Hyrax::BreadcrumbsForWorks

    # Redirect for Bot Detection
    before_action except: :oai do |controller|
      BotDetectionController.bot_detection_enforce_filter(controller) unless valid_bot?
    end

    # 'ir.library.oregonstate.edu,ir-staging.library.oregonstate.edu,test.lib.oregonstate.edu:3000'
    def valid_bot?
      ENV.fetch('URI_TURNSTILE_BYPASS', '').split(',').include?(request.domain) || allow_listed_ip_addr?
    end

    def allow_listed_ip_addr?
      ips = ENV.fetch('IP_TURNSTILE_BYPASS', '') # '127.0.0.1-127.255.255.255,66.249.64.0-66.249.79.255'
      ranges = ips.split(',')
      ranges.each do |range|
        range = range.split('-')
        range = (IPAddr.new(range[0]).to_i..IPAddr.new(range[1]).to_i)
        return true if range.include?(request.remote_ip.to_i)
      end
      false
    end

    self.curation_concern_type = GraduateThesisOrDissertation

    # Use this line if you want to use a custom presenter
    self.show_presenter = GraduateThesisOrDissertationPresenter

    before_action :ensure_admin!, only: :destroy

    private

    def ensure_admin!
      authorize! :read, :admin_dashboard
    end
  end
end
