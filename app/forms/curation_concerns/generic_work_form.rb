# Generated via
#  `rails generate curation_concerns:work GenericWork`
module CurationConcerns
  class GenericWorkForm < Sufia::Forms::WorkForm
    self.model_class = ::GenericWork
    include HydraEditor::Form::Permissions
    self.terms += [:resource_type]

    def self.date_terms
      [
        :accepted,
        :available,
        :copyrighted,
        :collected,
        :issued,
        :valid_date,
        :date
      ]
    end

    def self.build_permitted_params
      permitted = super

      date_terms.each do |date_term|
        permitted << {
          date_term => []
        }
      end

      permitted
    end

  end
end
