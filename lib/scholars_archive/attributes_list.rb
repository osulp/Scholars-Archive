# frozen_string_literal:true

module ScholarsArchive
  # List for displaying attributes on the show page. Order matters.
  module AttributesList
    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/MethodLength
    def self.base_attributes
      [
        { field: :alt_title, render_as: :linked, search_field: 'alternative_title_ssim', label: I18n.t('simple_form.labels.defaults.alt_title') },
        { field: :nested_ordered_creator_label, render_as: :scholars_archive_nested, search_field: 'nested_ordered_creator_label_ssim', itemprop_option: 'url', label: 'Creator' },
        { field: :nested_ordered_abstract_label, label: 'Abstract' },
        { field: :nested_ordered_contributor_label, render_as: :scholars_archive_nested, search_field: 'nested_ordered_contributor_label_ssim', itemprop_option: 'url', label: 'Contributor' },
        { field: :license_label, render_as: :search_and_external_link, search_field: 'license_label', label: I18n.t('simple_form.labels.defaults.license_label') },
        { field: :resource_type, render_as: :faceted, label: I18n.t('simple_form.labels.defaults.resource_type') },
        { field: :doi, render_as: :external_link, label: I18n.t('simple_form.labels.defaults.doi') },
        { field: :identifier, render_as: :search_and_external_link, search_field: 'identifier_tesim' },
        { field: :date_accepted, render_as: :edtf, search_field: 'date_accepted_sim' },
        { field: :date_available, render_as: :edtf, search_field: 'date_available_sim' },
        { field: :date_collected, render_as: :edtf, search_field: 'date_collected_sim' },
        { field: :date_copyright, render_as: :edtf, search_field: 'date_copyright_sim' },
        { field: :date_created, render_as: :edtf, search_field: 'date_created_sim' },
        { field: :date_issued, render_as: :edtf, search_field: 'date_issued_sim' },
        { field: :date_valid, render_as: :edtf, search_field: 'date_valid_sim' },
        { field: :date_reviewed, render_as: :edtf, search_field: 'date_reviewed_sim' },
        { field: :time_required, label: I18n.t('simple_form.labels.defaults.time_required') },
        { field: :typical_age_range, label: I18n.t('simple_form.labels.defaults.typical_age_range') },
        { field: :learning_resource_type, label: I18n.t('simple_form.labels.defaults.learning_resource_type') },
        { field: :interactivity_type, label: I18n.t('simple_form.labels.defaults.interactivity_type') },
        { field: :is_based_on_url, label: I18n.t('simple_form.labels.defaults.is_based_on_url') },
        { field: :degree_level, render_as: :faceted, label: I18n.t('simple_form.labels.defaults.degree_level') },
        { field: :degree_name, render_as: :faceted, label: I18n.t('simple_form.labels.defaults.degree_name') },
        { field: :degree_field_label, render_as: :search_and_external_link, label: I18n.t('simple_form.labels.defaults.degree_field'), search_field: 'degree_field_label' },
        { field: :degree_grantors_label, render_as: :search_and_external_link, label: I18n.t('simple_form.labels.defaults.degree_grantors'), search_field: 'degree_grantors_label' },
        { field: :graduation_year, render_as: :search_and_external_link, label: I18n.t('simple_form.labels.defaults.graduation_year') },
        { field: :contributor_advisor, render_as: :search_and_external_link, label: I18n.t('simple_form.labels.defaults.contributor_advisor') },
        { field: :contributor_committeemember, render_as: :search_and_external_link, label: I18n.t('simple_form.labels.defaults.contributor_committeemember') },
        { field: :bibliographic_citation, label: I18n.t('simple_form.labels.defaults.bibliographic_citation') },
        { field: :is_referenced_by, label: I18n.t('simple_form.labels.defaults.is_referenced_by') },
        { field: :has_journal, render_as: :search_and_external_link, label: I18n.t('simple_form.labels.defaults.has_journal') },
        { field: :has_volume, label: I18n.t('simple_form.labels.defaults.has_volume') },
        { field: :has_number, label: I18n.t('simple_form.labels.defaults.has_number') },
        { field: :conference_name, render_as: :search_and_external_link, label: I18n.t('simple_form.labels.defaults.conference_name') },
        { field: :conference_section, render_as: :search_and_external_link, label: I18n.t('simple_form.labels.defaults.conference_section') },
        { field: :conference_location, label: I18n.t('simple_form.labels.defaults.conference_location') },
        { field: :editor, label: I18n.t('simple_form.labels.defaults.editor') },
        { field: :academic_affiliation_label, render_as: :search_and_external_link, label: I18n.t('simple_form.labels.defaults.academic_affiliation'), search_field: 'academic_affiliation_label' },
        { field: :other_affiliation_label, render_as: :search_and_external_link, label: I18n.t('simple_form.labels.defaults.other_affiliation'), search_field: 'other_affiliation_label' },
        { field: :in_series, render_as: :search_and_external_link, label: I18n.t('simple_form.labels.defaults.in_series') },
        { field: :keyword, render_as: :search_and_external_link },
        { field: :subject, render_as: :search_and_external_link },
        { field: :tableofcontents, label: I18n.t('simple_form.labels.defaults.tableofcontents') },
        { field: :rights_statement_label, render_as: :search_and_external_link, search_field: 'rights_statement_label', label: I18n.t('simple_form.labels.defaults.rights_statement') },
        { field: :nested_related_items_label, render_as: :search_and_external_link, search_field: 'nested_related_items_label_ssim', itemprop_option: 'url', label: I18n.t('simple_form.labels.defaults.nested_related_items') },
        { field: :hydrologic_unit_code, label: I18n.t('simple_form.labels.defaults.hydrologic_unit_code') },
        { field: :nested_geo, render_as: :scholars_archive_nested, search_field: 'nested_geo_label_ssim', itemprop_option: 'geo', label: I18n.t('blacklight.search.form.nested_geo') },
        { field: :funding_statement, label: I18n.t('simple_form.labels.defaults.funding_statement') },
        { field: :publisher, render_as: :search_and_external_link },
        { field: :peerreviewed_label, render_as: :linked, search_field: 'peerreviewed_label', label: I18n.t('simple_form.labels.defaults.peerreviewed') },
        { field: :language_label, render_as: :search_and_external_link, search_field: 'language_label', label: I18n.t('simple_form.labels.defaults.language') },
        { field: :file_format, render_as: :search_and_external_link, label: I18n.t('simple_form.labels.defaults.file_format') },
        { field: :file_extent, label: I18n.t('simple_form.labels.defaults.file_extent') },
        { field: :digitization_spec, label: I18n.t('simple_form.labels.defaults.digitization_spec') },
        { field: :replaces, render_as: :external_link },
        { field: :nested_ordered_additional_information_label, label: 'Additional Information' },
        { field: :based_near_linked, render_as: :search_and_external_link, label: 'Location', search_field: 'based_near_label' },
        { field: :funding_body, render_as: :faceted, label: I18n.t('simple_form.labels.defaults.funding_body') },
        { field: :embargo_reason },
        { field: :embargo_date_range },
        { field: :duration, label: I18n.t('simple_form.labels.defaults.duration') },
        { field: :isbn, label: I18n.t('simple_form.labels.defaults.isbn') },
        { field: :issn, label: I18n.t('simple_form.labels.defaults.issn') }
      ]
    end
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/MethodLength
  end
end
