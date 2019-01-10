# frozen_string_literal: true

class MultiValueDateInput < MultiValueInput
  def input_type
    'multi_value'.freeze
  end

  private

  def build_field(value, index)
    date_options = build_field_options(value, index)
    toggle_options = toggle_range_options(index)

    if date_range?(value)
      date_options[:placeholder] = 'YYYY-mm-dd/YYY-mm-dd'
      toggle_options[:checked] = 'checked'

    else
      date_options[:placeholder] = 'YYYY-mm-dd'
    end

    input_date = input_date_outer_wrapper(value) do
      @builder.text_field(value, date_options)
    end
    input_toggle_range = @builder.text_field('', toggle_options)
    toggle_checkbox = toggle_checkbox_wrapper do
      build_toggle_range_checkbox(input_toggle_range, index)
    end

    calendar_widget = build_calendar_widget(value, index)

    date_field_inputs = date_field_inputs_wrapper(index) do
     "#{input_date}#{calendar_widget}"
    end

    "#{date_field_inputs}#{toggle_checkbox}"
  end

  def toggle_checkbox_wrapper
    "<div class= \"form-check\">#{yield}</div>"
  end

  def date_field_inputs_wrapper(index)
    "<div id=\"date_field_inputs_#{attribute_name}_#{index}\" class=\"date_inputs\" data-term=\"#{attribute_name}\">#{yield}</div>"
  end

  def input_date_outer_wrapper(value)
    <<-HTML
      <div class="row">
        <div class="col-sm-12">
          <div class="date-input #{date_input_class(value)}">
          #{yield}
          </div>
        </div>
      </div>
    HTML
  end

  def date_input_class(value)
    date_range?(value) ? 'date-range' : 'date-default'
  end

  def build_toggle_range_checkbox(value, index)
    label_options = build_field_options('', index)
    label_options[:for] = "toggle_date_range_#{index}"
    label_options[:class] = ['form_check_label']
    label_options[:name] = "toggle_date_range_#{index}_label"
    label_toggle_range = @builder.label('Date range', label_options)
    "#{value}#{label_toggle_range}"
  end

  def build_calendar_widget(value, index)
    calendar_widget_outer_wrapper do
      date_range?(value) ? "#{build_start_calendar(value, index)}#{build_end_calendar(index)}" : ''
    end
  end

  def calendar_widget_outer_wrapper
    "<div class=\"row date-range-inputs\">#{yield}</div>"
  end

  def calendar_icon_outer_wrapper
    "<div class=\"input-group-btn\">#{yield}</div>"
  end

  def calendar_input_outer_wrapper
    <<-HTML
      <div class="col-sm-6">
        <div class="input-group">
          #{yield}
        </div>
      </div>
    HTML
  end

  def build_start_calendar(value, index)
    start_date_options = start_date_options(index)
    input_start_date = @builder.text_field('', start_date_options)

    start_calendar_options = start_calendar_options(index)
    button_start_calendar = @builder.button :button, start_calendar_options do
      calendar_icon
    end

    calendar_input_outer_wrapper do
      btn_icon = calendar_icon_outer_wrapper do
        button_start_calendar
      end
      "#{input_start_date}#{btn_icon}"
    end
  end

  def build_end_calendar(index)
    end_date_options = end_date_options(index)
    input_end_date = @builder.text_field('', end_date_options)

    end_calendar_options = end_calendar_options(index)
    button_end_calendar = @builder.button :button, end_calendar_options do
      calendar_icon
    end

    calendar_input_outer_wrapper do
      btn_icon = calendar_icon_outer_wrapper do
        button_end_calendar
      end
      "#{input_end_date}#{btn_icon}"
    end
  end

  def end_calendar_options(index)
    options = build_field_options('', index)
    options[:type] = 'button'
    options[:name] = 'calendar_end'
    options[:class] = ['calendar_end']
    options['aria-label'.to_sym] = 'Calendar End'
    options
  end

  def start_calendar_options(index)
    options = build_field_options('', index)
    options[:type] = 'button'
    options[:name] = 'calendar_start'
    options[:class] = ['calendar_start']
    options['aria-label'.to_sym] = 'Calendar Start'
    options
  end

  def calendar_icon
    '<span class="glyphicon glyphicon-calendar"></span>'.html_safe
  end

  def date_range?(value)
    d = Date.edtf(value)
    d.instance_of? EDTF::Interval
  end

  def toggle_range_options(index)
    options = build_field_options('', index)
    options[:type] = 'checkbox'
    options[:name] = "toggle_date_range_#{index}"
    options[:id] = "toggle_date_range_#{index}"
    options['data-id'.to_sym] = "#{attribute_name}_#{index}"
    options['data-index'.to_sym] = index
    options['data-term'.to_sym] = attribute_name
    options[:class] = ['form-check-multiple-input', 'toggle_date_range']
    options
  end

  def start_date_options(index)
    options = build_field_options('',index)
    options[:placeholder] = 'Start date'
    options[:class] = ['form-control', 'timepicker_start']
    options[:type] = ['text']
    options[:name] = start_date_id(index)
    options[:id] = start_date_id(index)
    options
  end

  def end_date_options(index)
    options = build_field_options('', index)
    options[:placeholder] = 'End date'
    options[:class] = ['form-control', 'timepicker_end']
    options[:type] = ['text']
    options[:name] = end_date_id(index)
    options[:id] = end_date_id(index)
    options
  end

  def start_date_id(index)
    "timepicker_start_#{attribute_name}_#{index}"
  end

  def end_date_id(index)
    "timepicker_end_#{attribute_name}_#{index}"
  end
end
