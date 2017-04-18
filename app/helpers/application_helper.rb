module ApplicationHelper
  def select_tag_dates(name, f)
    options = []
    data_fields = [{ id: 'dates_fields_data' }]

    f.object.date_terms.each do |term|
      if f.object.send(term).blank?
        options << { term.to_s.titleize => term.to_s }
      end
      data_field = render partial: 'scholars_archive/base/form_date_field', :locals => { term: term, f: f }
      data_range_widget = render partial: 'scholars_archive/base/form_date_range_widget', :locals => { term: term }
      data_fields << { term => data_field }
      data_fields << { 'range_'+term.to_s => data_range_widget }
    end

    default_option = {"Select a date type" => "default_option"}
    date_options = Hash[options.blank? ? [] : options.reduce(:merge).sort]
    date_options = default_option.merge(date_options)

    select_tag(name, options_for_select(date_options), {
      class: 'form-control',
      data: data_fields.reduce(:merge)
    })
  end

  def date_range?(term, f)
    input = f.object.send(term)
    d = Date.edtf(input)
    d.instance_of? EDTF::Interval
  end
end
