module ScholarsArchive 
  module ArticleWorkFormBehavior
    extend ActiveSupport::Concern
    included do
      self.terms += [:resource_type, :editor, :has_volume, :has_number, :conference_location, :conference_name, :conference_section, :has_journal, :is_referenced_by]
      def primary_terms
        super
      end

      def secondary_terms
        super - self.date_terms + [:editor, :has_volume, :has_number, :conference_location, :conference_name, :conference_section, :has_journal, :is_referenced_by, :isbn]
      end
    end
  end
end
