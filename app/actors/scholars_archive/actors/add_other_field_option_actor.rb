# frozen_string_literal: true

module ScholarsArchive
  module Actors
    # The Hyrax::AddOtherFieldOptionActor responds to two primary actions:
    # * #create
    # * #update
    # it must instantiate the next actor in the chain and instantiate it.
    class AddOtherFieldOptionActor < Hyrax::Actors::AbstractActor
      # @param [Hyrax::Actors::Environment] env
      # @return [Boolean] true if create was successful
      def create(env)
        next_actor.create(env) && save_custom_option(env)
      end

      # @param [Hyrax::Actors::Environment] env
      # @return [Boolean] true if update was successful
      def update(env)
        next_actor.update(env) && update_custom_option(env)
      end

      private

      def degree_present?(env)
        env.curation_concern.respond_to?(:degree_field) && env.curation_concern.respond_to?(:degree_level) && env.curation_concern.respond_to?(:degree_name)
      end

      def save_custom_option(env)
        puts 'save custom option if any'
        if degree_present?(env)
          if env.attributes['degree_field_other'].present? && is_valid_other_field_multiple?(env, :degree_field)
            puts 'saving degree field other and notifying admin'
            all_new_entries = persist_multiple_other_entries(env, :degree_field)
            notify_admin(env, field: :degree_field, new_entries: all_new_entries)
          end
          if env.attributes['degree_level_other'].present? && is_valid_other_field?(env, :degree_level)
            puts 'degree level other and notifying admin'
            OtherOption.find_or_create_by(name: env.curation_concern.degree_level_other.to_s, work_id: env.curation_concern.id, property_name: :degree_level.to_s)
            notify_admin(env, field: :degree_level, new_entries: env.curation_concern.degree_level_other)
          end
          if env.attributes['degree_name_other'].present? && is_valid_other_field_multiple?(env, :degree_name)
            puts 'degree name other and notifying admin'
            all_new_entries = persist_multiple_other_entries(env, :degree_name)
            notify_admin(env, field: :degree_name, new_entries: all_new_entries)
          end
        end

        if env.curation_concern.respond_to?(:degree_grantors) && env.curation_concern.degree_grantors.present? && env.curation_concern.respond_to?(:degree_grantors_other) && env.curation_concern.degree_grantors_other.present?
          puts 'degree grantors other and notifying admin'
          OtherOption.find_or_create_by(name: env.curation_concern.degree_grantors_other.to_s, work_id: env.curation_concern.id, property_name: :degree_grantors.to_s)
          notify_admin(env, field: :degree_grantors, new_entries: env.curation_concern.degree_grantors_other)
        end

        if other_affiliation_other_present?(env)
          puts 'other affiliation other and notifying admin'
          all_new_entries = persist_multiple_other_entries(env, :other_affiliation)
          notify_admin(env, field: :other_affiliation, new_entries: all_new_entries)
        end

        clean_up_fields(env)
        true
      end

      def clean_up_fields(env)
        env.attributes.delete('degree_field_other') if env.attributes['degree_field']
        env.attributes.delete('degree_name_other') if env.attributes['degree_name']
        env.attributes.delete('degree_grantors_other') if env.attributes['degree_grantors']
        env.attributes.delete('degree_level_other') if env.attributes['degree_level']
      end

      def other_affiliation_other_present?(env)
        env.curation_concern.respond_to?(:other_affiliation_other) && env.curation_concern.other_affiliation_other.present? && valid_other_affiliation_other?(env.curation_concern, field: :other_affiliation.to_s, collection: other_affiliation_options(env.user))
      end

      def other_affiliation_options(env_user)
        service = ScholarsArchive::OtherAffiliationService.new
        env_user.admin? ? service.select_sorted_all_options : service.select_active_options
      end

      def is_valid_other_field?(env, field)
        ScholarsArchive::FieldValidationService.is_valid_other_field?(env.curation_concern, field: field, env_user: env.user)
      end

      def is_valid_other_field_multiple?(env, field)
        ScholarsArchive::FieldValidationService.is_valid_other_field_multiple?(env.curation_concern, env_attributes: env.attributes, field: field, env_user: env.user)
      end

      def valid_other_affiliation_other?(record, field: nil, collection: [])
        other_field = "#{field}_other".to_sym
        other_value = record.send(other_field) if record.respond_to?(other_field)
        error_counter = 0
        if other_value.present?
          other_value.each do |entry|
            error_counter += 1 if other_value_in_collection? other_value: entry, collection: collection
          end
        end
        error_counter <= 0
      end

      def other_value_in_collection?(other_value: nil, collection: [])
        !collection.select { |option| option.include? other_value }.empty? ? true : false
      end

      def persist_multiple_other_entries(env, field)
        puts 'persist multiple other entries'
        all_current_entries = get_all_other_options(env, field).map(&:name)
        all_new_entries = []
        other_field = "#{field}_other"

        return all_new_entries if env.attributes[other_field].blank?

        env.attributes[other_field].each do |entry|
          puts 'entry check'
          unless all_current_entries.include? entry
            OtherOption.find_or_create_by(name: entry.to_s, work_id: env.curation_concern.id, property_name: field.to_s)
            all_new_entries << entry.to_s
          end
        end
        all_new_entries
      end

      def update_custom_option(env)
        if degree_present?(env)
          if is_valid_other_field_multiple?(env, :degree_field)

            all_new_entries = persist_multiple_other_entries(env, :degree_field)
            notify_admin(env, field: :degree_field, new_entries: all_new_entries)
          end

          if env.curation_concern.degree_level_other.present? && is_valid_other_field?(env, :degree_level)
            degree_level_other_option = get_other_option(env, :degree_level)
            if degree_level_other_option.present?
              OtherOption.update(degree_level_other_option.id, name: env.curation_concern.degree_level_other.to_s)
            else
              OtherOption.find_or_create_by(name: env.curation_concern.degree_level_other.to_s, work_id: env.curation_concern.id, property_name: :degree_level.to_s)
              notify_admin(env, field: :degree_level, new_entries: env.curation_concern.degree_level_other)
            end
          end

          if is_valid_other_field_multiple?(env, :degree_name)
            puts 'degree name other and notifying admin'
            all_new_entries = persist_multiple_other_entries(env, :degree_name)
            notify_admin(env, field: :degree_name, new_entries: all_new_entries)
          end
        end

        if degree_grantors_present?(env.curation_concern)
          degree_grantors_other_option = get_other_option(env, :degree_grantors)
          if degree_grantors_other_option.present?
            OtherOption.update(degree_grantors_other_option.id, name: env.curation_concern.degree_grantors_other.to_s)
          else
            OtherOption.find_or_create_by(name: env.curation_concern.degree_grantors_other.to_s, work_id: env.curation_concern.id, property_name: :degree_grantors.to_s)
            notify_admin(env, field: :degree_grantors, new_entries: env.curation_concern.degree_grantors_other)
          end
        end

        if other_affiliation_other_present?(env)
          all_new_entries = persist_multiple_other_entries(env, :other_affiliation)
          notify_admin(env, field: :other_affiliation, new_entries: all_new_entries)
        end

        clean_up_fields(env)
        true
      end

      def degree_grantors_present?(record)
        record.respond_to?(:degree_grantors) && record.degree_grantors.present? && record.respond_to?(:degree_grantors_other) && record.degree_grantors_other.present?
      end

      def notify_admin(env, field:, new_entries:)
        return unless new_entries.present? && new_entries.respond_to?(:size) && new_entries.size.positive?

        ScholarsArchive::OtherOptionCreateSuccessService.new(env.curation_concern,
                                                             field: field,
                                                             new_entries: new_entries).call
      end

      def get_other_option(env, field)
        OtherOption.find_by(work_id: env.curation_concern.id, property_name: field.to_s)
      end

      def get_all_other_options(env, field)
        OtherOption.where(work_id: env.curation_concern.id, property_name: field.to_s)
      end
    end
  end
end
