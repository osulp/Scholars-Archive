module ScholarsArchive
  module SetDefaultTermBehavior
    extend ActiveSupport::Concern
    included do
      DEFAULT_PRIMARY_TERMS = %i[
        nested_ordered_title
        alt_title
        nested_ordered_creator
        nested_ordered_contributor
        contributor_advisor
        nested_ordered_abstract
        license
        resource_type
        doi
        dates_section
        degree_level
        degree_name
        degree_field
        bibliographic_citation
        academic_affiliation
        other_affiliation
        in_series
        subject
        tableofcontents
        rights_statement
      ]

      DEFAULT_SECONDARY_TERMS = %i[
        nested_related_items
        hydrologic_unit_code
        geo_section
        funding_statement
        publisher
        peerreviewed
        conference_name
        conference_section
        conference_location
        language
        file_format
        file_extent
        digitization_spec
        replaces
        nested_ordered_additional_information
        isbn
        issn
      ]

      DEFAULT_SECONDARY_ADMIN_TERMS =  %i[
        keyword
        source
        funding_body
        dspace_community
        dspace_collection
        description
        identifier
      ]
    end
  end
end