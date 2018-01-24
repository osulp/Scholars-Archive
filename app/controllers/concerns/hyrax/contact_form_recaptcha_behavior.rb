module Hyrax
  module ContactFormRecaptchaBehavior
    def check_recaptcha
      if Hyrax.config.recaptcha?
        if verify_recaptcha(model: @contact_form)
        else
          flash.now[:error] = 'Captcha did not verify properly.'
          flash.now[:error] << @contact_form.errors.full_messages.map(&:to_s).join(", ")
          render :new
        end
      end
    end
  end
end
