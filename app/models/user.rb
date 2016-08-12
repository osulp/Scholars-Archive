class User < ActiveRecord::Base
  # Connects this user object to Hydra behaviors.
  include Hydra::User

  # Connects this user object to Role-management behaviors.
  include Hydra::RoleManagement::UserRoles


  # Connects this user object to Role-management behaviors.
  include Hydra::RoleManagement::UserRoles
  # Connects this user object to Curation Concerns behaviors.
  include CurationConcerns::User
  # Connects this user object to Sufia behaviors.
  include Sufia::User
  include Sufia::UserUsageStats

  if Blacklight::Utils.needs_attr_accessible?
    attr_accessible :email, :password, :password_confirmation
  end
  # Connects this user object to Blacklights Bookmarks.
  include Blacklight::User
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :cas_authenticatable

  # Method added by Blacklight; Blacklight uses #to_s on your
  # user class to get a user-displayable login/identifier for
  # the account.
  def to_s
    email
  end

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
end
