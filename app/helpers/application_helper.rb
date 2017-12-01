module ApplicationHelper
  def select_tag_dates(name, f)
    options = []
    data_fields = [{ id: 'dates_fields_data' }]

    f.object.date_terms.each do |term|

      if f.object.multiple? term
        options << { term.to_s.titleize => term.to_s } if f.object.send(term).first.blank?
        data_field = render_edit_field_partial(term, f: f)
      else
        options << { term.to_s.titleize => term.to_s } if f.object.send(term).blank?
        data_field = render partial: 'scholars_archive/base/form_date_field', :locals => { term: term, f: f }
      end

      data_range_widget = render partial: 'scholars_archive/base/form_date_range_widget', :locals => { term: term }

      data_fields << { term => data_field }
      data_fields << { 'range_'+term.to_s => data_range_widget }
    end

    data_fields << { 'work_type' => f.object.model_name.singular }

    default_option = {"Select a date type" => "default_option"}
    date_options = Hash[options.blank? ? [] : options.reduce(:merge).sort]
    date_options = default_option.merge(date_options)

    select_tag(name, options_for_select(date_options), {
      class: 'form-control',
      data: data_fields.reduce(:merge)
    })
  end

  def select_tag_geo(name, f)
    options = []
    data_fields = [{ id: 'geo_fields_data' }]

    coordinates = f.object.model.nested_geo.to_a
    
    if coordinates.none? { |h| h.type == :bbox.to_s }
      options << { t('simple_form.labels.defaults.nested_geo_bbox').pluralize => :nested_geo_bbox.to_s }
    end

    if coordinates.none? { |h| h.type == :point.to_s }
      options << { t('simple_form.labels.defaults.nested_geo_points').pluralize => :nested_geo_points.to_s }
    end

    new_geo_point = [f.object.model.nested_geo.build]
    new_geo_point.first.type = :point.to_s
    data_geo_point = f.fields_for :nested_geo, new_geo_point, child_index: new_geo_point.object_id do |a|
      render partial: 'scholars_archive/base/geo_point', :locals => { a: a }
    end
    data_geo_points = render partial: 'scholars_archive/base/nested_geo_points', :locals => { f: f, coordinates_group: new_geo_point }
    data_fields << { nested_geo_points: data_geo_points }
    data_fields << { new_geo_point: data_geo_point }
    data_fields << { new_geo_point_id: new_geo_point.object_id }

    new_geo_bbox = [f.object.model.nested_geo.build]
    new_geo_bbox.first.type = :bbox.to_s
    data_geo_bbox = f.fields_for :nested_geo, new_geo_bbox, child_index: new_geo_bbox.object_id do |a|
      render partial: 'scholars_archive/base/geo_bbox', :locals => { a: a }
    end
    data_geo_boxes = render partial: 'scholars_archive/base/nested_geo_bbox', :locals => { f: f, coordinates_group: new_geo_bbox }
    data_fields << { nested_geo_bbox: data_geo_boxes }
    data_fields << { new_geo_box: data_geo_bbox }
    data_fields << { new_geo_box_id: new_geo_bbox.object_id }

    f.object.model.nested_geo = coordinates

    default_option = {"Select a geographic coordinate type" => "default_option"}
    geo_options = Hash[options.blank? ? [] : options.reduce(:merge).sort]
    geo_options = default_option.merge(geo_options)

    select_tag(name, options_for_select(geo_options), {
        class: 'form-control',
        data: data_fields.reduce(:merge)
    })
  end

  def date_range?(term, f)
    input = f.object.send(term)
    d = Date.edtf(input)
    d.instance_of? EDTF::Interval
  end

  def link_to_sa_field(field, query)
    search_path = Rails.application.class.routes.url_helpers.search_catalog_path(:f => {field => [query]})
    link_to(query, search_path)
  end

  def facet_desc_sort!(items=[])
    items.sort! { |a,b| b.value.downcase <=> a.value.downcase }
    items
  end

  def fixed_work_type_order(items=[])
    model_list = []
    items.each {|item| model_list.push(item) }
    fixed_ordered_list = [Article, EescPublication, GraduateThesisOrDissertation, TechnicalReport, GraduateProject, AdministrativeReportOrPublication, HonorsCollegeThesis, ConferenceProceedingsOrJournal, UndergraduateThesisOrProject, OpenEducationalResource, Dataset, Default]
    lookup = {}
    model_list.each { |item| lookup[item.concern] = item }
    fixed_ordered_list.each.map { |item| lookup[item] }
  end

  def embargo_select_options
    [["6 Months",6.months.from_now], ["1 year",1.year.from_now],["2 Years",2.years.from_now], ["Other...", "other"]]
  end

  def selected_embargo(release_date, options)
    options_hash = options.map { |option| option.second.instance_of?(ActiveSupport::TimeWithZone) ? [option.first, option.second.strftime('%Y-%m-%d')] : option }.to_h
    key = options_hash.key(release_date.strftime('%Y-%m-%d'))
    value = options.to_h[key]
    value ? value : 'other'
  end
end
