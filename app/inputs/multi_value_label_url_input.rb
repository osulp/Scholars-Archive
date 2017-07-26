class MultiValueLabelUrlInput < MultiValueInput
  def input_type
    'multi_value'.freeze
  end

  private

  def build_field(value, index)
    if value.new_record?
      index = value.object_id
    end
    label_options = build_label_options(value.label.first, index)
    input_label = @builder.text_field(:label, label_options)

    related_url_options = build_url_options(value.related_url.first, index)
    input_related_url = @builder.text_field(:related_url, related_url_options)

    unless value.new_record?
      id_options = build_id_options(value.id, index)
      input_id = @builder.text_field(:id, id_options)
    end

    "#{input_id ||= '' }#{input_label}#{input_related_url}"
  end

  def build_id_options(value, index)
    options = build_field_options(value, index)
    options[:class] = ['form-control', 'hidden']
    options[:type] = ['hidden']
    options[:name] = nested_field_name(:id.to_s, index)
    options[:id] = nested_field_id(:id.to_s, index)
    options
  end

  def build_label_options(value, index)
    options = build_field_options(value, index)
    options[:name] = nested_field_name(:label.to_s, index)
    options[:id] = nested_field_id(:label.to_s, index)
    options[:placeholder] = 'Label'
    options
  end

  def build_url_options(value, index)
    options = build_field_options(value, index)
    options[:name] = nested_field_name(:related_url.to_s, index)
    options[:id] = nested_field_id(:related_url.to_s, index)
    options[:placeholder] = 'Related Url'
    options
  end

  def nested_field_name(property, index)
    "#{object_name}[#{attribute_name}_attributes][#{index.to_s}][#{property}]"
  end

  def nested_field_id(property, index)
    "#{object_name}_#{attribute_name}_attributes_#{index.to_s}_#{property}"
  end

  def collection
    @collection ||= begin
      val = object[attribute_name]
      val.reject { |value| value.to_s.strip.blank? }.sort_by { |h| h[:id] }.reverse!
    end
  end
end