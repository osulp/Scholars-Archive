# frozen_string_literal: true

# Ability object
class Ability
  include Hydra::Ability

  include Hyrax::Ability
  self.ability_logic += [:everyone_can_create_curation_concerns]

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

    can %i[edit update], SolrDocument do |solr_doc|
      (AdminSet.where(title: solr_doc.admin_set).first.edit_users.include?(current_user.username) || current_user.admin?) if solr_doc.admin_set.present? && current_user.present?
    end

    can %i[edit update], ActiveFedora::Base do |record|
      record.admin_set.edit_users.include?(current_user.username) || current_user.admin?
    end
  end
end
