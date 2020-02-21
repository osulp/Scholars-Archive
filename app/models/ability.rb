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

    can(%i[read], SolrDocument, visibility: 'restricted') do |solr_doc| 
      Rails.logger.info "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
      solr_doc.depositor == current_user.username
    end

    can(%i[read], ActiveFedora::Base, visibility: 'restricted') do |record| 
      Rails.logger.info "2!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
      record.depositor == current_user.username
    end

    can(%i[show], SolrDocument, visibility: 'restricted') do |solr_doc| 
      Rails.logger.info "3!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
      solr_doc.depositor == current_user.username
    end

    can(%i[show], ActiveFedora::Base, visibility: 'restricted') do |record| 
      Rails.logger.info "4!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
      record.depositor == current_user.username
    end
  end
end
