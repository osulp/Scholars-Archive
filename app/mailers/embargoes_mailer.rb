class EmbargoesMailer < ActionMailer::Base
  default :from => 'noreply@oregonstate.edu'

  def embargoes_lifted_email(items, from, to, subject, error)
    @items = items
    @error = error
    mail(:from => from, :to => to, :subject => subject)
  end
end
