# frozen_string_literal: true

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
        <div class='dd-handle dd3-handle #{text_area_handle_class(value)}'></div>
        <div class='input-group-btn group-up-down-arrows #{multi_input_nested_item_class(value)} #{text_area_class(value)}'>
          <button type='button' class='btn btn-default up-arrow' aria-label='Move Up' data-toggle='tooltip' data-placement='top' title='Move Up'>
            <span class='glyphicon glyphicon-arrow-up ordered-up-arrow'></span>
          </button>

          <button type='button' class='btn btn-default down-arrow' aria-label='Move Down' data-toggle='tooltip' data-placement='top' title='Move Down'>
            <span class='glyphicon glyphicon-arrow-down ordered-down-arrow'></span>
          </button>
        </div>
        #{yield}
      </li>
    "
  end

  def multi_input_nested_item_class(value)
    "#{'multi-input-nested-item' if has_multi_input_elements?(value)}"
  end

  def text_area_class(value)
    "#{'text-area-nested-field' if is_text_area?(value)}"
  end

  def text_area_handle_class(value)
    "#{'text-area-dd-handle' if is_text_area?(value)}"
  end

  def has_multi_input_elements?(value)
    value.is_a?(NestedRelatedItems)
  end

  def is_text_area?(value)
    value.is_a?(NestedOrderedAbstract) || value.is_a?(NestedOrderedAdditionalInformation)
  end

  def outer_wrapper
    " <ul class='listing draggable-order dd-list' data-object-name='#{object_name}'>
        #{yield}
      </ul>
    "
  end

  private

  def build_field(value, index)
    if value.new_record?
      index = value.object_id
    end

    if value.is_a?(NestedOrderedCreator)
      item_options = build_item_options(value, index, :creator)
      input_field = @builder.text_field(:creator, item_options)
    elsif value.is_a?(NestedOrderedTitle)
      item_options = build_item_options(value, index, :title)
      input_field = @builder.text_field(:title, item_options)
    elsif value.is_a?(NestedOrderedAbstract)
      item_options = build_item_options(value, index, :abstract)
      input_field = @builder.text_area(:abstract, item_options)
    elsif value.is_a?(NestedOrderedContributor)
      item_options = build_item_options(value, index, :contributor)
      input_field = @builder.text_field(:contributor, item_options)
    elsif value.is_a?(NestedOrderedAdditionalInformation)
      item_options = build_item_options(value, index, :additional_information)
      input_field = @builder.text_area(:additional_information, item_options)
    elsif value.is_a?(NestedRelatedItems)
      item_options = build_item_options(value, index, :label)
      url_options = build_item_options(value, index, :related_url)
      input_field = @builder.text_field(:label, item_options)
      input_field_2 = @builder.text_field(:related_url, url_options)
    end

    index_options = build_index_options(value, index)
    input_index = @builder.text_field(:index, index_options)

    unless value.new_record?
      id_options = build_id_options(value.id, index)
      input_id = @builder.text_field(:id, id_options)
    end

    if value.destroy_item == true
      destroy_options = build_destroy_options(value.id, index)
      destroy_input = @builder.text_field(:_destroy, destroy_options)
    end

    nested_item = "#{input_field}#{input_field_2}#{input_index}"

    "#{input_id ||= '' }#{destroy_input ||= '' }#{nested_item}"
  end

  def build_nested_item(value,index)
    index_options = build_index_options(value, index)
    input_index = @builder.text_field(:index, index_options)

    if value.is_a?(NestedOrderedCreator)
      creator_options = build_creator_options(value, index)
      input_creator = @builder.text_field(:creator, creator_options)
      nested_item = "#{input_creator}#{input_index}"
    elsif value.is_a?(NestedOrderedTitle)
      title_options = build_title_options(value, index)
      input_title = @builder.text_field(:title, title_options)
      nested_item = "#{input_title}#{input_index}"
    elsif value.is_a?(NestedRelatedItems)
      label_options = build_related_items_label_options(value, index)
      url_options = build_related_items_url_options(value, index)
      input_label = @builder.text_field(:label, label_options)
      input_url = @builder.text_field(:related_url, url_options)
      nested_item = "#{input_label}#{input_url}#{input_index}"
    end
    "#{nested_item ||= ''}"
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
    options[:value] = '1'
    options
  end

  def build_item_options(value, index, method)
    creator_value = value.send(method).first
    options = build_field_options(creator_value, index)
    options[:name] = nested_field_name(method.to_s, index)
    options[:id] = nested_field_id(method.to_s, index)
    options[:placeholder] = method.to_s.titleize if prop_with_labels.include?(method)
    options
  end

  def build_index_options(value, index)
    index_value = value.index.first
    options = build_field_options(index_value, index)
    options[:name] = nested_field_name(:index.to_s, index)
    options[:id] = nested_field_id(:index.to_s, index)
    options[:class] << 'index'
    options[:placeholder] = 'Index'
    options[:type] = ['hidden']
    options
  end

  def prop_with_labels
    %i[label related_url]
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
      val.reject { |value| value.to_s.strip.blank? }.sort_by { |h| h[:index].first.to_i }
    end
  end
end
