# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work PurchasedEResource`
module Hyrax
  # form object for PER
  class PurchasedEResourceForm < DefaultForm
    include ::ScholarsArchive::TriplePoweredProperties::TriplePoweredForm
    include ScholarsArchive::EtdWorkFormBehavior
    include ScholarsArchive::ArticleWorkFormBehavior

    self.required_fields = [:nested_ordered_title]
    self.terms -= %i[creator title]
    self.terms -= %i[nested_ordered_creator nested_ordered_title]

    self.model_class = ::PurchasedEResource

    def primary_terms
      %i[nested_ordered_title alt_title nested_ordered_creator nested_ordered_contributor nested_ordered_abstract license resource_type doi identifier dates_section bibliographic_citation is_referenced_by has_journal has_volume has_number conference_location conference_name conference_section editor academic_affiliation other_affiliation in_series subject tableofcontents rights_statement] | %i[nested_ordered_title alt_title nested_ordered_creator nested_ordered_contributor nested_ordered_abstract license resource_type doi identifier dates_section degree_level degree_name degree_field degree_grantors graduation_year bibliographic_citation academic_affiliation other_affiliation in_series subject tableofcontents rights_statement] | super
    end
  end
end
