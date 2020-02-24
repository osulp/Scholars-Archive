# frozen_string_literal: true

module ScholarsArchive
  # works controller behavior
  module WorksControllerBehavior
    extend ActiveSupport::Concern
    include Hyrax::WorksControllerBehavior
    included do
      before_action :redirect_mismatched_work, only: [:show]
      before_action :scrub_params, only: %i[update create]

      def redirect_mismatched_work
        curation_concern = ActiveFedora::Base.find(params[:id])
        redirect_to(main_app.polymorphic_path(curation_concern), status: :moved_permanently) and return if curation_concern.class != _curation_concern_type
      end

      # OVERRIDE FROM HYRAX TO INSERT SOLR DOCUMENT INTO DOCUMENT LIST IF THE WORK WAS INGESTED BY THE CURRENT USER
      def search_result_document(search_params)
        _, document_list = search_results(search_params)
        solr_doc = ::SolrDocument.find(params[:id])
        document_list << solr_doc if solr_doc.depositor == current_user.username
        return document_list.first unless document_list.empty?

        document_not_found!
      end
    end

    def new
      curation_concern.publisher = ['Oregon State University']
      curation_concern.rights_statement = ['http://rightsstatements.org/vocab/InC/1.0/']
      curation_concern.degree_grantors = 'http://id.loc.gov/authorities/names/n80017721' if curation_concern.respond_to?(:degree_grantors)
      super
    end

    def edit
      parse_geo
      get_other_option_values
      super
    end

    def update
      set_other_option_values
      super
    end

    def create
      set_other_option_values
      super
    end

    private

    def scrub_params
      ScholarsArchive::ParamScrubber.scrub(params, hash_key_for_curation_concern)
    end

    def set_embargo_release_date
    end

    def mutate_embargo_date
      translated_date = date_string.split.first.to_i.send(date_string.split.second.to_sym).from_now.to_date
      params[hash_key_for_curation_concern]['embargo_release_date'] = Date.parse(translated_date.to_date.to_s).strftime('%Y-%m-%d')
    end

    def set_other_option_values
      # if the user selected the "Other" option in "degree_field" or "degree_level", and then provided a custom
      # value in the input shown when selecting this option, these custom values would be assigned to the
      # "degree_field_other" and "degree_level_other" attribute accessors so that they can be accessed by
      # AddOtherFieldOptionActor. This actor will persist them in the database for reviewing later by an admin user
      curation_concern.degree_field_other = params[hash_key_for_curation_concern]['degree_field_other'] if params[hash_key_for_curation_concern]['degree_field'] == 'Other' && params[hash_key_for_curation_concern]['degree_field_other'].present?

      curation_concern.degree_level_other = params[hash_key_for_curation_concern]['degree_level_other'] if params[hash_key_for_curation_concern]['degree_level'] == 'Other' && params[hash_key_for_curation_concern]['degree_level_other'].present?

      curation_concern.degree_name_other = params[hash_key_for_curation_concern]['degree_name_other'] if params[hash_key_for_curation_concern]['degree_name'] == 'Other' && params[hash_key_for_curation_concern]['degree_name_other'].present?

      curation_concern.degree_grantors_other = params[hash_key_for_curation_concern]['degree_grantors_other'] if params[hash_key_for_curation_concern]['degree_grantors'] == 'Other' && params[hash_key_for_curation_concern]['degree_grantors_other'].present?

      curation_concern.current_username = current_user.username
    end

    def get_other_option_values
      @degree_field_other_options = get_all_other_options('degree_field')
      curation_concern.degree_field_other = degree_field_other_option.name if @degree_field_other_options.present? && curation_concern.degree_field.present? && curation_concern.degree_field == 'Other'
      @degree_name_other_options = get_all_other_options('degree_name')
      curation_concern.degree_name_other = degree_name_other_option.name if @degree_name_other_options.present? && curation_concern.degree_name.present? && curation_concern.degree_name == 'Other'
      degree_level_other_option = get_other_options('degree_level')
      curation_concern.degree_level_other = degree_level_other_option.name if degree_level_other_option.present? && curation_concern.degree_level.present? && curation_concern.degree_level == 'Other'
      degree_grantors_other_option = get_other_options('degree_grantors')
      curation_concern.degree_grantors_other = degree_grantors_other_option.name if degree_grantors_other_option.present? && curation_concern.degree_grantors.present? && curation_concern.degree_grantors == 'Other'
      @other_affiliation_other_options = get_all_other_options('other_affiliation')
    end

    def parse_geo
      curation_concern.nested_geo.each do |geo|
        if geo.bbox.present?
          # bbox is stored as a string array of lat/long string arrays like: '["121.1", "121.2", "44.1", "44.2"]', however only one array of lat/long array is stored, so the first will need to be converted to simple array of strings like: ["121.1","121.2","44.1","44.2"]
          box_array = geo.bbox.to_a.first.tr('[]" ', '').split(',')
          geo.bbox_lat_north = box_array[0]
          geo.bbox_lon_west = box_array[1]
          geo.bbox_lat_south = box_array[2]
          geo.bbox_lon_east = box_array[3]
          geo.type = :bbox.to_s
        end
        if geo.point.present?
          # point is stored as a string array of lat/long string arrays like: '["121.1", "121.2"]', however only one array of lat/long array is stored, so the first will need to be converted to simple array of strings like: ["121.1","121.2"]
          point_array = geo.point.to_a.first.tr('[]" ', '').split(',')
          geo.point_lat = point_array[0]
          geo.point_lon = point_array[1]
          geo.type = :point.to_s
        end
      end
    end

    def get_other_options(property)
      OtherOption.find_by(work_id: curation_concern.id, property_name: property)
    end

    def get_all_other_options(property)
      OtherOption.where(work_id: curation_concern.id, property_name: property.to_s)
    end
  end
end
