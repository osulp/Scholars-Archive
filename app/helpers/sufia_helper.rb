module SufiaHelper
  include ::BlacklightHelper
  include Sufia::BlacklightOverride
  include Sufia::SufiaHelperBehavior

  def link_to_facet(field, field_string)
    if field['preflabel']
      link_to(field['preflabel'].first, catalog_index_path(add_facet_params(field_string, field['id'])))
    else
      link_to(field, add_facet_params(field_string, field).merge!(controller: "catalog", action: "index"))
    end
  end

  def link_to_fields(fields, field_string)
    fields.map { |tag| link_to_facet(tag, field_string) }
  end

end
