class MultiValueOrderedInput < MultiValueInput
  def input_type
    'multi_value'.freeze
  end

  def input(wrapper_options)
    @rendered_first_element = false
    input_html_classes.unshift('string')
    input_html_options[:name] ||= "#{object_name}[#{attribute_name}][]"

    outer_wrapper do
      buffer_each(collection) do |value, index|
        inner_wrapper(value, index) do
          build_field(value, index)
        end
      end
    end
  end

  protected

  def inner_wrapper(value, index)
    "
      <li class='field-wrapper dd-item'>
        <div class='dd-handle dd3-handle'></div>\n
        #{yield}\n
        <input type='hidden' name=#{nested_field_name(value, index)} id=#{nested_field_id(value, index)} />
      </li>\n
    "
  end

  def outer_wrapper
    " <ul class='listing draggable-order dd-list'>\n        
        #{yield}\n      
      </ul>\n
    "
  end

  private

  def build_field(value, index)
    label_options = build_label_options(value, index)
    input_label = @builder.text_field(:creator, label_options)
  
    if value.destroy_item == true
      destroy_options = build_destroy_options(value.id, index)
      destroy_input = @builder.text_field(:_destroy, destroy_options)
    end
  
    "#{destroy_input ||= '' }#{nested_item}"
  end

  def nested_item_wrapper(value)
    "<div class= \"#{attribute_name} related_item multi-value-label-url #{'has-error' if value.validation_msg.present?} \">#{yield}</div>"
  end

  def nested_item_help_block_wrapper
    "<span class=\"help-block\">#{yield}</span>"
  end

  def build_id_options(value, index)
    options = build_field_options(value, index)
    options[:class] = ['form-control', 'hidden']
    options[:type] = ['hidden']
    options[:name] = nested_field_name(:id.to_s, index)
    options[:id] = nested_field_id(:id.to_s, index)
    options
  end

  def build_destroy_options(value, index)
    # example:
    # <input type="hidden" name="article[nested_related_items_attributes][0][_destroy]" id="article_nested_related_items_attributes_0__destroy" value="1">
    options = build_field_options(value, index)
    options[:class] = ['hidden']
    options[:type] = ['hidden']
    options[:name] = nested_field_name(:_destroy.to_s, index)
    options[:id] = nested_field_id(:_destroy.to_s, index)
    options[:value] = "1"
    options
  end

  def build_label_options(value, index)
    label_value = value.creator.first
    options = build_field_options(label_value, index)
    options[:name] = nested_field_name(:label.to_s, index)
    options[:id] = nested_field_id(:label.to_s, index)
    options[:placeholder] = 'Label'
    options[:readonly] = 'readonly' if value.validation_msg.present? || label_value.present?
    options
  end

  def build_url_options(value, index)
    url_value = value.related_url.first
    options = build_field_options(url_value, index)
    options[:name] = nested_field_name(:related_url.to_s, index)
    options[:id] = nested_field_id(:related_url.to_s, index)
    options[:placeholder] = 'Related Url'
    options[:readonly] = 'readonly' if value.validation_msg.present? || url_value.present?
    options
  end

  def nested_field_name(property, index)
    "#{object_name}[#{attribute_name}_attributes][#{index.to_s}][#{property}]"
  end

  def nested_field_id(property, index)
    "#{object_name}_#{attribute_name}_attributes_#{index.to_s}_#{property}"
  end
end
