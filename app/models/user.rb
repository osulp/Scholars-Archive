class User < ActiveRecord::Base
  # Connects this user object to Hydra behaviors.
  include Hydra::User# Connects this user object to Sufia behaviors.
  include Sufia::User
  include Sufia::UserUsageStats

  # CAS authentication has been known to return user details missing email
  before_validation :handle_missing_email

  validates :username, presence: true
  validates :email, presence: true

  attr_accessible :email, :password, :password_confirmation if Rails::VERSION::MAJOR < 4
  # Connects this user object to Blacklights Bookmarks.
  include Blacklight::User
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :cas_authenticatable

  # Handle CAS extra attributes and save to DB
  def cas_extra_attributes=(extra_attributes)
    extra_attributes.each do |name, value|
      case name.to_sym
      when :fullname
        self.display_name = value
      when :email
        self.email = value
      end
    end
  end

  # Method added by Blacklight; Blacklight uses #to_s on your
  # user class to get a user-displayable login/identifier for
  # the account.
  def to_s
    email
  end

  # provides a basic default/unique email address, and a means to detect
  # if the user is still misconfigured. ApplicationController can redirect user
  # to thier profile to fix the email address if it is still set as the default
  def default_email
    "noreply-#{self.username}@oregonstate.edu"
  end

  def has_default_email?
    self.email == default_email
  end

  protected
  # CAS has been known to not include user email addresses, set to something
  # that can be identified and cleaned up, send error email to support
    def handle_missing_email
      if self.email.empty?
        UserMailer.support_invalid_user(self, "Email address was missing during user creation, setting to default #{default_email} and redirecting to user update it.").deliver_now
        #TODO: email CAS support?
        self.email = default_email
      end
    end
end
