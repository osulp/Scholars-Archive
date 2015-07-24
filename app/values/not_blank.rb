##
# Value object to deal with blank values.
# @todo Evaluate this. May not be worth it
class NotBlank
  pattr_initialize :value

  def value
    if @value.blank?
      nil
    else
      @value
    end
  end
end
