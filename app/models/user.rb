# frozen_string_literal: true

# user object
class User < ApplicationRecord
  # Connects this user object to Hydra behaviors.
  include Hydra::User
  # Connects this user object to Role-management behaviors.
  include Hydra::RoleManagement::UserRoles
  # Connects this user object to Hyrax behaviors.
  include Hyrax::User
  include Hyrax::UserUsageStats

  attr_accessible :email, :password, :password_confirmation if Blacklight::Utils.needs_attr_accessible?
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

  # method needed for messaging
  def mailboxer_email(_obj = nil)
    email
  end

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

  # Update the user fields from the university API if they haven't been fetched before, or if the configured
  # number of seconds have elapsed since the previous update occurred.
  def update_from_person_api
    right_now = DateTime.now.in_time_zone(ScholarsArchive::Application.config.time_zone)
    if !api_person_updated_at || api_person_updated_at + ENV['OSU_API_PERSON_REFRESH_SECONDS'].to_i.seconds < right_now
      service = ScholarsArchive::OsuApiService.new
      person = service.get_person(username)
      self.api_person_type = person['attributes']['primaryAffiliation']
      self.api_person_updated_at = DateTime.now
      # TODO: set api_student_type to nil, undergraduate, or graduate once the Person API has been extended to support fetching this data
      save
    end
  end

  # If api_person_type is set, evaluate if the user is an employee or not. Default to
  # true in the case where the API could not provide the details per users preference
  # in Banner.
  def employee?
    return api_person_type.casecmp('employee').zero? if api_person_type

    true
  end

  def student_employee?
    roles.map(&:name).include? "Student-Employee"
  end
  
  # If api_person_type is set, evaluate if the user is an student or not. Default to
  # true in the case where the API could not provide the details per users preference
  # in Banner.
  def student?
    return api_person_type.casecmp('student').zero? if api_person_type

    true
  end
end
