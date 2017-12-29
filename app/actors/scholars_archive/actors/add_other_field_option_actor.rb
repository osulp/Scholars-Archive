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
        error_counter = 0

        if degree_present? (env)
          # check if degree_level_other is already in the list or is missing
          error_counter += validate_other_value? env, field: :degree_level, collection: degree_level_options(env.user)

          # check if degree_field_other is already in the list or is missing
          error_counter += validate_other_value_multiple? env, field: :degree_field, collection: degree_field_options(env.user)

          # check if degree_name_other is already in the list or is missing
          error_counter += validate_other_value? env, field: :degree_name, collection: degree_name_options(env.user)

          # check if degree_grantors_other is already in the list or is missing
          error_counter += validate_other_value? env, field: :degree_grantors, collection: degree_grantors_options(env.user)
        end

        if other_affiliation_other_present? (env)
          # check if other_affiliation_other is already in the list or is missing
          error_counter += validate_other_value_multiple? env, field: :other_affiliation, collection: other_affiliation_options(env.user)
        end

        (error_counter > 0) ? false : true
      end

      def validate_other_value? (env, field: nil, collection: [])
        other_field = "#{field}_other".to_sym
        other_value = env.curation_concern.send(other_field)
        error_counter = 0
        if other_value.present?
          if other_value_in_collection? other_value: other_value, collection: collection
            env.curation_concern.errors.add(other_field, I18n.translate(:"simple_form.actor_validation.other_value_exists", other_entry: other_value.to_s))
            error_counter += 1
          end
        else
          if env.attributes[field.to_s] == 'Other'
            env.curation_concern.errors.add(other_field, I18n.t("simple_form.actor_validation.other_value_missing"))
            error_counter += 1
          end
        end
        return error_counter
      end

      # This will now check if there is value passed in, since this can be used for optional fields (i.e. other_affiliation)
      # as well as required ones with multiples allowed (i.e. degree_field)
      def validate_other_value_multiple? (env, field: nil, collection: [])
        other_field = "#{field}_other".to_sym
        other_value = env.curation_concern.send(other_field)
        error_counter = 0

        valid_values = []
        if other_value.present?
          other_value.each do |entry|
            if other_value_in_collection? other_value: entry, collection: collection
              err_message = I18n.translate(:"simple_form.actor_validation.other_value_exists", other_entry: entry.to_s)
              env.curation_concern.errors.add(other_field, I18n.translate(:"simple_form.actor_validation.other_value_exists", other_entry: entry.to_s))
              env.curation_concern.send(other_field) << [{option: "Other", err_msg: err_message, other_entry: entry.to_s}.to_json]
              error_counter += 1
            else
              valid_values << entry.to_s
            end
          end
        else
          if env.attributes[field.to_s] == ['Other']
            env.curation_concern.errors.add(other_field, I18n.t("simple_form.actor_validation.other_value_missing"))
            error_counter += 1
          end
        end

        if error_counter > 0
          valid_values.each do |entry|
            env.curation_concern.send(other_field) << [{option: "Other", err_valid_val:true, other_entry: entry.to_s}.to_json]
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

      def degree_grantors_options(env_user)
        service = ScholarsArchive::DegreeGrantorsService.new
        env_user.admin? ? service.select_sorted_all_options : service.select_active_options
      end

      def other_affiliation_options(env_user)
        service = ScholarsArchive::OtherAffiliationService.new
        env_user.admin? ? service.select_sorted_all_options : service.select_active_options
      end

      def degree_present? (env)
        env.attributes['degree_field'].present? && env.attributes['degree_level'].present? && env.attributes['degree_name'].present?
      end

      def other_affiliation_other_present? (env)
        env.curation_concern.other_affiliation_other.present?
      end

      def save_custom_option(env)
        puts "save custom option"
        if degree_present? (env)
          if env.curation_concern.degree_field_other.present?
            puts "degree field other"
            all_new_entries = persist_multiple_other_entries(env, :degree_field)
            notify_admin(env, field: :degree_field, new_entries: all_new_entries)
          end
          if env.curation_concern.degree_level_other.present?
            OtherOption.find_or_create_by(name: env.curation_concern.degree_level_other.to_s, work_id: env.curation_concern.id, property_name: :degree_level.to_s)
            notify_admin(env, field: :degree_level, new_entries: env.curation_concern.degree_level_other)
          end
          if env.curation_concern.degree_name_other.present?
            OtherOption.find_or_create_by(name: env.curation_concern.degree_name_other.to_s, work_id: env.curation_concern.id, property_name: :degree_name.to_s)
            notify_admin(env, field: :degree_name, new_entries: env.curation_concern.degree_name_other)
          end
          if env.curation_concern.degree_grantors_other.present?
            OtherOption.find_or_create_by(name: env.curation_concern.degree_grantors_other.to_s, work_id: env.curation_concern.id, property_name: :degree_grantors.to_s)
            notify_admin(env, field: :degree_grantors, new_entries: env.curation_concern.degree_grantors_other)
          end
        end

        if other_affiliation_other_present? (env)
          all_new_entries = persist_multiple_other_entries(env, :other_affiliation)
          notify_admin(env, field: :other_affiliation, new_entries: all_new_entries)
        end

        return true
      end

      def persist_multiple_other_entries(env, field)
        puts "persist multiple other entries"
        all_current_entries = get_all_other_options(env, field).map(&:name)
        all_new_entries = []
        env.curation_concern.send("#{field.to_s}_other").each do |entry|
          puts "entry check"
          unless all_current_entries.include? entry
            OtherOption.find_or_create_by(name: entry.to_s, work_id: env.curation_concern.id, property_name: field.to_s)
            all_new_entries << entry.to_s
          end
        end
        return all_new_entries
      end

      def update_custom_option(env)
        if degree_present? (env)
          if env.curation_concern.degree_field_other.present?

            all_new_entries = persist_multiple_other_entries(env, :degree_field)
            notify_admin(env, field: :degree_field, new_entries: all_new_entries)
          end
#            degree_field_other_option = get_other_option(env, :degree_field)
#            if degree_field_other_option.present?
#              OtherOption.update(degree_field_other_option.id, name: env.curation_concern.degree_field_other.to_s)
#            else
#              OtherOption.find_or_create_by(name: env.curation_concern.degree_field_other.to_s, work_id: env.curation_concern.id, property_name: :degree_field.to_s)
#              notify_admin(env, field: :degree_field, new_entries: env.curation_concern.degree_field_other)
#            end
#          end

          if env.curation_concern.degree_level_other.present?
            degree_level_other_option = get_other_option(env, :degree_level)
            if degree_level_other_option.present?
              OtherOption.update(degree_level_other_option.id, name: env.curation_concern.degree_level_other.to_s)
            else
              OtherOption.find_or_create_by(name: env.curation_concern.degree_level_other.to_s, work_id: env.curation_concern.id, property_name: :degree_level.to_s)
              notify_admin(env, field: :degree_level, new_entries: env.curation_concern.degree_level_other)
            end
          end

          if env.curation_concern.degree_name_other.present?
            degree_name_other_option = get_other_option(env, :degree_name)
            if degree_name_other_option.present?
              OtherOption.update(degree_name_other_option.id, name: env.curation_concern.degree_name_other.to_s)
            else
              OtherOption.find_or_create_by(name: env.curation_concern.degree_name_other.to_s, work_id: env.curation_concern.id, property_name: :degree_name.to_s)
              notify_admin(env, field: :degree_name, new_entries: env.curation_concern.degree_name_other)
            end
          end

          if env.curation_concern.degree_grantors_other.present?
            degree_grantors_other_option = get_other_option(env, :degree_grantors)
            if degree_grantors_other_option.present?
              OtherOption.update(degree_grantors_other_option.id, name: env.curation_concern.degree_grantors_other.to_s)
            else
              OtherOption.find_or_create_by(name: env.curation_concern.degree_grantors_other.to_s, work_id: env.curation_concern.id, property_name: :degree_grantors.to_s)
              notify_admin(env, field: :degree_grantors, new_entries: env.curation_concern.degree_grantors_other)
            end
          end
        end

        if other_affiliation_other_present? (env)
          all_new_entries = persist_multiple_other_entries(env, :other_affiliation)
          notify_admin(env, field: :other_affiliation, new_entries: all_new_entries)
        end

        return true
      end

      def notify_admin(env, field:, new_entries:)
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
