# Generated via
#  `rails generate hyrax:work PurchasedEResource`
module Hyrax
  class PurchasedEResourceForm < DefaultForm
    include ::ScholarsArchive::TriplePoweredProperties::TriplePoweredForm
    include ScholarsArchive::EtdWorkFormBehavior
    include ScholarsArchive::ArticleWorkFormBehavior

    self.required_fields = [:title]

    self.model_class = ::PurchasedEResource

    def primary_terms
      [:title, :alt_title, :creator, :contributor, :abstract, :license, :resource_type, :doi, :identifier, :dates_section, :bibliographic_citation, :is_referenced_by, :has_journal, :has_volume, :has_number, :conference_location, :conference_name, :conference_section, :editor, :academic_affiliation, :other_affiliation, :in_series, :subject, :tableofcontents, :rights_statement] | [:title, :alt_title, :creator, :contributor, :abstract, :license, :resource_type, :doi, :identifier, :dates_section, :degree_level, :degree_name, :degree_field, :degree_grantors, :graduation_year, :contributor_advisor, :contributor_committeemember, :bibliographic_citation, :academic_affiliation, :other_affiliation, :in_series, :subject, :tableofcontents, :rights_statement] | super
    end
  end
end
