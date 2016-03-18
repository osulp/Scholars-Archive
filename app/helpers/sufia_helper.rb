module SufiaHelper
  include ::BlacklightHelper
  include Sufia::BlacklightOverride
  include Sufia::SufiaHelperBehavior

  def link_to_facet(field, field_string)
    if field['preflabel']
      link_to(preffered_uri_label(field), catalog_index_path(add_facet_params(field_string, field['id'])))
    else
      link_to(field, add_facet_params(field_string, field).merge!(controller: "catalog", action: "index"))
    end
  end

  def link_to_fields(fields, field_string)
    fields.map { |tag| link_to_facet(tag, field_string) }
  end

  def link_to_field(fieldname, fieldvalue, displayvalue = nil)
    if fieldvalue["id"]
      p = { search_field: 'advanced', fieldname => '"' + fieldvalue["id"] + '"' }
    else
      p = { search_field: 'advanced', fieldname => '"' + fieldvalue + '"' }
    end
    link_url = catalog_index_path(p)
    if fieldvalue["preflabel"]
      display = displayvalue.blank? ? fieldvalue["preflabel"] : displayvalue
    elsif fieldvalue["id"]
      display = displayvalue.blank? ? fieldvalue["id"] : displayvalue
    else
      display = displayvalue.blank? ? fieldvalue : displayvalue
    end
    link_to(display, link_url)
  end

  def preffered_uri_label(field)
    TriplePoweredResource.new(RDF::URI(field['id'])).preferred_label
  end
end

