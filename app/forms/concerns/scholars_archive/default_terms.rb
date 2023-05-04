#frozen_string_literal:true

module ScholarsArchive
  # Houses terms for Defaults
  module DefaultTerms
		def self.base_terms
			self.primary_terms + self.secondary_terms + self.admin_terms + self.date_terms +
			%i[date_uploaded
				date_modified
				nested_geo
				file_format
				embargo_reason]
		end

		def self.primary_terms
			%i[nested_ordered_title
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
				rights_statement]
		end

		def self.secondary_terms
			%i[nested_related_items
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
				issn]
		end

		def self.admin_terms
			%i[keyword
				source
				funding_body
				dspace_community
				dspace_collection
				description
				identifier
				documentation]
		end

		def self.date_terms
			%i[date_available
				date_copyright
				date_issued
				date_collected
				date_valid
				date_reviewed
				date_accepted]
		end
	end
end
