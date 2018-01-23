Hyrax::Workflow::StatusListService.class_eval do

  attr_writer :recaptcha
  attr_reader :recaptcha
  def recaptcha?
    @recaptcha ||= false
  end
end
