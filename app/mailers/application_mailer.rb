# frozen_string_literal: true

# mailer for application
class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch('SCHOLARSARCHIVE_ADMIN_EMAIL', 'scholarsarchive@oregonstate.edu')
  layout 'mailer'
end
