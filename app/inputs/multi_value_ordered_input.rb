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
        <input type='hidden' name='#{nested_field_name(value, index)}' id='#{nested_field_id(value, index)}'' />
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
    unless value.is_a?(String)
      if value.new_record?
        index = value.object_id
      end
      label_options = build_label_options(value, index)
      input_label = @builder.text_field(:nested_ordered_creator_label, label_options)

      unless value.new_record?
        id_options = build_id_options(value.id, index)
        input_id = @builder.text_field(:id, id_options)
      end

      if value.destroy_item == true
        destroy_options = build_destroy_options(value.id, index)
        destroy_input = @builder.text_field(:_destroy, destroy_options)
      end

      help_block = nested_item_help_block_wrapper do
        value.validation_msg.present? ? value.validation_msg : ''
      end

      if value.validation_msg.present?
        nested_item = nested_item_wrapper(value) do
          "#{help_block}#{input_label}"
        end
      else
        nested_item = "#{input_label}"
      end

      "#{input_id ||= '' }#{destroy_input ||= '' }#{nested_item}"
    end
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
    options[:name] = nested_field_name(:creator.to_s, index)
    options[:id] = nested_field_id(:creator.to_s, index)
    options[:placeholder] = 'Label'
    options[:readonly] = 'readonly' if value.validation_msg.present? || label_value.present?
    options
  end

  def nested_field_name(property, index)
    "#{object_name}[#{attribute_name}_attributes][#{index.to_s}][#{property}]"
  end

  def nested_field_id(property, index)
    "#{object_name}_#{attribute_name}_attributes_#{index.to_s}_#{property}"
  end
end
