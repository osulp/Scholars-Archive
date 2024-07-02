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
      admin? || can_review_submissions? || (AdminSet.where(title: solr_doc.admin_set).first.edit_users.include?(current_user.username) if solr_doc.admin_set.present?)
    end

    can %i[edit update], ActiveFedora::Base do |record|
      admin? || can_review_submissions? || (record.admin_set.edit_users.include?(current_user.username) if record.respond_to?(:admin_set))
    end
  end
  def can_import_works?
    can_create_any_work?
  endend
