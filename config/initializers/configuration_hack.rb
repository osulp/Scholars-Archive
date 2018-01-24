Hyrax::Configuration.class_eval do
  attr_writer :recaptcha
  attr_reader :recaptcha
  def recaptcha?
    @recaptcha ||= false
  end

  @recaptcha = true

  # Enables the use of Google ReCaptcha on the contact form.
  # A site key and secret key need to be supplied in order for google
  # to authenticate and authorize/validate the 
  #
  # ReCaptcha site key and secret key, supplied by google after
  # registering a domain.
  # config.recaptcha_site_key = "xxxx_XXXXXXXXXXfffffffffff"
  # WARNING: KEEP THIS SECRET. DO NOT STORE IN REPOSITORY
  # config.recaptcha_secret_key = "xxxx_XXXXXXXXXXfffffffffff"
end
