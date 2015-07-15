class HasHintOption < SimpleDelegator
  def options
    super.merge({:hint => hint})
  end

  def hint
    "Must fulfill: #{hint_message}" unless hint_message.empty?
  end

  private

  def hint_message
    object.property_hint(property)
  end
end
