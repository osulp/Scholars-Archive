module Hyrax
  class ContactFormRecaptchaBehavior < ApplicationController

    def create
      if Hyrax.config.recaptcha && verify_recaptcha(model: @contact_form)
        super
      else
        flash.now[:error] = 'Captcha did not verify properly.'
        flash.now[:error] << @contact_form.errors.full_messages.map(&:to_s).join(", ")
      end
      render :new
    rescue RuntimeError => exception
      handle_create_exception(exception)
    end
  end
end
