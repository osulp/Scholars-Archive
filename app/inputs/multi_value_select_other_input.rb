# frozen_string_literal: true

# Multi value select other input
class MultiValueSelectOtherInput < MultiValueSelectInput
  # Overriding so that we can handle the "Other" option with an input
  def input_type
    'multi_value'.freeze
  end

  private

  def build_field(value, index)
    render_options = select_options
    if %w[err_msg err_valid_val].any? { |msg| value.include? msg }
      error = JSON.parse(value)
      value = error['option']
      other_entry_value = error['other_entry']
      err_msg = error['err_msg']
    end

    html_options = build_field_options(value)
    (render_options, html_options) = options[:item_helper].call(value, index, render_options, html_options) if options[:item_helper]
    select_input = template.select_tag(attribute_name, template.options_for_select(render_options, value), html_options)

    other_input_op = other_input_options(index, other_entry_value, value)

    input = @builder.text_field('', other_input_op)

    help_block = other_input_help_block_wrapper do
      err_msg.present? ? err_msg : ''
    end

    other_input = other_input_wrapper(err_msg) do
      "#{help_block}#{input}"
    end

    "#{select_input}#{other_input}"
  end

  def other_input_wrapper(error)
    "<div class= \"#{attribute_name}_other #{'has-error' if error.present?} multi-value-select-other\">#{yield}</div>"
  end

  def other_input_help_block_wrapper
    "<span class=\"help-block\">#{yield}</span>"
  end

  def other_input_options(index, other_value, value)
    show_hide_element = show_hide_class(other_value, value)
    options = build_field_options('')
    options[:value] = other_value if other_value.present?
    options[:placeholder] = 'Other value'
    options[:class] = ['form-control'] + show_hide_element
    options[:type] = show_hide_element.include?('hidden') ? show_hide_element : ['text']
    options[:required] = 'required' if show_hide_element.empty?
    options[:name] = other_option_name
    options[:id] = index.zero? ? other_option_id : ''
    options
  end

  def show_hide_class(element, value)
    element.present? || value == 'Other' ? [] : ['hidden']
  end

  def other_option_name
    "#{object_name}[#{attribute_name}_other][]"
  end

  def other_option_id
    "#{object_name}_#{attribute_name}_other"
  end
end
