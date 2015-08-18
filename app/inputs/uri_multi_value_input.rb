class UriMultiValueInput < MultiValueWithHelpInput
  include WithHelpIcon

  def input_type
    'uri_multi_value'.freeze
  end
  
  protected

  def build_field(value, index)
    options = build_field_options(value, index)
    ScholarsArchive::URIEnabledStringField.new(@builder, attribute_name, options).field
  end
end
