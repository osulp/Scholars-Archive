# Generated via
#  `rails generate hyrax:work Article`
module Hyrax
  class ArticleForm < Hyrax::DefaultWorkForm
    include ScholarsArchive::DateTermsBehavior
    include ScholarsArchive::NestedGeoBehavior
    self.model_class = ::Article
    self.terms += [:resource_type, :editor, :has_volume, :has_number, :conference_location, :conference_name, :conference_section, :has_journal, :is_referenced_by]
    def primary_terms
      super
    end

    def secondary_terms
      super - self.date_terms + [:editor, :has_volume, :has_number, :conference_location, :conference_name, :conference_section, :has_journal, :is_referenced_by, :isbn]
    end
  end
end
