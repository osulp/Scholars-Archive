module ScholarsArchive
  module Actors
    # The Hyrax::AddOtherFieldOptionActor responds to two primary actions:
    # * #create
    # * #update
    # it must instantiate the next actor in the chain and instantiate it.
    class AddOtherFieldOptionActor < Hyrax::Actors::BaseActor
      # @param [Hyrax::Actors::Environment] env
      # @return [Boolean] true if create was successful
      def create(env)
        validate(env) && save_custom_option(env) && next_actor.create(env)
      end

      # @param [Hyrax::Actors::Environment] env
      # @return [Boolean] true if update was successful
      def update(env)
        validate(env) && update_custom_option(env) && next_actor.update(env)
      end

      private

      def validate(env)
        return true unless degree_present? (env)
        error_counter = 0

        # check if degree_level_other is already in the list or is missing
        error_counter += validate_other_value? env, field: :degree_level, collection: degree_level_options(env.user)

        # check if degree_field_other is already in the list or is missing
        error_counter += validate_other_value? env, field: :degree_field, collection: degree_field_options(env.user)

        # check if degree_name_other is already in the list or is missing
        error_counter += validate_other_value? env, field: :degree_name, collection: degree_name_options(env.user)

        (error_counter > 0) ? false : true
      end

      def validate_other_value? (env, field: nil, collection: [])
        other_field = "#{field}_other".to_sym
        other_value = env.curation_concern.send(other_field)
        error_counter = 0
        if other_value.present?
          if other_value_in_collection? other_value: other_value, collection: collection
            env.curation_concern.errors.add(other_field, I18n.t('simple_form.actor_validation.other_value_exists'))
            error_counter += 1
          end
        else
          if env.attributes[field.to_s] == 'Other'
            env.curation_concern.errors.add(other_field, I18n.t('simple_form.actor_validation.other_value_missing'))
            error_counter += 1
          end
        end
        return error_counter
      end

      def other_value_in_collection? (other_value: nil, collection: [])
        !collection.select {|option| option.include? other_value}.empty? ? true : false
      end

      def degree_field_options(env_user)
        service = ScholarsArchive::DegreeFieldService.new
        env_user.admin? ? service.select_sorted_all_options : service.select_sorted_current_options
      end

      def degree_level_options(env_user)
        service = ScholarsArchive::DegreeLevelService.new
        env_user.admin? ? service.select_sorted_all_options : service.select_active_options
      end

      def degree_name_options(env_user)
        service = ScholarsArchive::DegreeNameService.new
        env_user.admin? ? service.select_sorted_all_options : service.select_active_options
      end

      def degree_present? (env)
        env.attributes['degree_field'].present? && env.attributes['degree_level'].present? && env.attributes['degree_name'].present?
      end

      def save_custom_option(env)
        return true unless degree_present? (env)
        if env.curation_concern.degree_field_other.present?
          OtherOption.find_or_create_by(name: env.curation_concern.degree_field_other.to_s, work_id: env.curation_concern.id, property_name: :degree_field.to_s)
          notify_admin(env, :degree_field)
        end
        if env.curation_concern.degree_level_other.present?
          OtherOption.find_or_create_by(name: env.curation_concern.degree_level_other.to_s, work_id: env.curation_concern.id, property_name: :degree_level.to_s)
          notify_admin(env, :degree_level)
        end
        if env.curation_concern.degree_name_other.present?
          OtherOption.find_or_create_by(name: env.curation_concern.degree_name_other.to_s, work_id: env.curation_concern.id, property_name: :degree_name.to_s)
          notify_admin(env, :degree_name)
        end
        return true
      end

      def update_custom_option(env)
        return true unless degree_present? (env)
        if env.curation_concern.degree_field_other.present?
          degree_field_other_option = get_other_option(env, :degree_field)
          if degree_field_other_option.present?
            OtherOption.update(degree_field_other_option.id, name: env.curation_concern.degree_field_other.to_s)
          else
            OtherOption.find_or_create_by(name: env.curation_concern.degree_field_other.to_s, work_id: env.curation_concern.id, property_name: :degree_field.to_s)
            notify_admin(env, :degree_field)
          end
        end

        if env.curation_concern.degree_level_other.present?
          degree_level_other_option = get_other_option(env, :degree_level)
          if degree_level_other_option.present?
            OtherOption.update(degree_level_other_option.id, name: env.curation_concern.degree_level_other.to_s)
          else
            OtherOption.find_or_create_by(name: env.curation_concern.degree_level_other.to_s, work_id: env.curation_concern.id, property_name: :degree_level.to_s)
            notify_admin(env, :degree_level)
          end
        end

        if env.curation_concern.degree_name_other.present?
          degree_name_other_option = get_other_option(env, :degree_name)
          if degree_name_other_option.present?
            OtherOption.update(degree_name_other_option.id, name: env.curation_concern.degree_name_other.to_s)
          else
            OtherOption.find_or_create_by(name: env.curation_concern.degree_name_other.to_s, work_id: env.curation_concern.id, property_name: :degree_name.to_s)
            notify_admin(env, :degree_name)
          end
        end
        return true
      end

      def notify_admin(env, field)
        ScholarsArchive::OtherOptionCreateSuccessService.new(env.curation_concern, field: field).call
      end

      def get_other_option(env, field)
        OtherOption.find_by(work_id: env.curation_concern.id, property_name: field.to_s)
      end
    end
  end
end
