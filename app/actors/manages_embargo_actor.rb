module ManagesEmbargoActor
  extend ActiveSupport::Concern

  def interpret_visibility
    interpret_embargo_visibility
  end

  def interpret_embargo_visibility
    if attributes[:visibility] != Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_EMBARGO
      # clear embargo_release_date even if it isn't being used. Otherwise it sets the embargo_date
      # even though they didn't select embargo on the form.
      attributes.delete(:visibility_during_embargo)
      attributes.delete(:visibility_after_embargo)
      attributes.delete(:embargo_release_date)
      generic_file.deactivate_embargo!
      generic_file.embargo.save if generic_file.embargo
      generic_file.visibility = attributes[:visibility]
      true
    elsif !attributes[:embargo_release_date]
      generic_file.errors.add(:visibility, 'When setting visibility to "embargo" you must also specify embargo release date.')
      false
    else
      attributes.delete(:visibility)
      generic_file.apply_embargo(attributes[:embargo_release_date], attributes.delete(:visibility_during_embargo),
                                 attributes.delete(:visibility_after_embargo))
      if generic_file.embargo
        generic_file.embargo.save
      end 
      generic_file.save
      true
    end
  end
end
