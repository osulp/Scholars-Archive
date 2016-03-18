class UserMailer < ActionMailer::Base
  default :from => 'noreply@oregonstate.edu'

  def support_invalid_user(user, message)
    @user = user
    @message = message ||= ""
    mail(:from => APPLICATION_CONFIG['notifications']['support_email'], :to => APPLICATION_CONFIG['notifications']['support_email'], :subject => '[ScholarsArchive] Invalid User Detected')
  end
  def shared_access_to(user, generic_file, access_level)
    @user = user
    @generic_file = generic_file
    @access_level = access_level
    mail(:from => APPLICATION_CONFIG['notifications']['support_email'], :to => @user.email, :subject => "[ScholarsArchive] You've been granted #{@access_level} access to '#{@generic_file[:title].first}'")
  end
end
