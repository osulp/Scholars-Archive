module ScholarsArchive
  module ManagesEmbargoActor
    extend ActiveSupport::Concern

    def interpret_visibility
      interpret_embargo_visibility
    end

    def interpret_embargo_visibility
      if attributes[:visibility] != Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_EMBARGO
        attributes.delete(:visibility_during_embargo)
        attributes.delete(:visibility_after_embargo)
        attributes.delete(:embargo_release_date)
        true
      elsif !attributes[:embargo_release_date]
        generic_file.errors.add(:visibility, 'When setting visibility to "embargo" you must also specify embargo release date.')
        false
      else
        attributes.delete(:visibility)
        binding.pry
        generic_file.apply_embargo(attributes[:embargo_release_date], attributes.delete(:visibility_during_embargo), attributes.delete(:visibility_after_embargo))
        generic_file.save 
        true
      end
    end
  end
end
