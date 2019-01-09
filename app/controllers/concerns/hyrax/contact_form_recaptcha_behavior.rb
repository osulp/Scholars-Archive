# frozen_string_literal: true

module Hyrax
  module ContactFormRecaptchaBehavior
    def check_recaptcha
      if is_recaptcha?
        if verify_recaptcha(model: @contact_form)
          true
        else
          flash[:error] = 'Captcha did not verify properly.'
          flash[:error] << @contact_form.errors.full_messages.dup.map(&:to_s).dup.join(', ')
          false
        end
      else
        true
      end
    end

    def is_recaptcha?
      Hyrax.config.recaptcha?
    end
  end
end
