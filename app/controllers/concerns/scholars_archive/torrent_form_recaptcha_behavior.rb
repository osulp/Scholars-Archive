# frozen_string_literal: true

module ScholarsArchive
  # CLASS: Torrent Form Recaptcha Controller
  module TorrentFormRecaptchaBehavior
    # METHOD: Check the recaptcha to see if verify or not
    def check_recaptcha
      if is_recaptcha?
        if verify_recaptcha(model: @torrent_form)
          true
        else
          flash[:error] = 'Captcha did not verify properly.'
          false
        end
      else
        true
      end
    end

    # METHOD: A check method to see if recaptcha exist
    # rubocop:disable Naming/PredicateName
    def is_recaptcha?
      Hyrax.config.recaptcha?
    end
    # rubocop:enable Naming/PredicateName
  end
end
