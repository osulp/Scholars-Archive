class Ability
  include Hydra::Ability
  include Sufia::Ability

  
  def generic_file_abilities
    if user_groups.include? 'admin'
      can :view_share_work, GenericFile
      can :create, [GenericFile, Collection] if user_groups.include? 'admin'
    end
    can :citation, GenericFile
  end
  # Define any customized permissions here.
  def custom_permissions
    # Limits deleting objects to a the admin user
    #
    # if current_user.admin?
    #   can [:destroy], ActiveFedora::Base
    # end

    # Limits creating new objects to a specific group
    #
    # if user_groups.include? 'special_group'
    #   can [:create], ActiveFedora::Base
    # end
  end
end
