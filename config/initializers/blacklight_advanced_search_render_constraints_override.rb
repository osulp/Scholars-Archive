# Copied from blacklight_advanced_search, includes change from this unmerged PR: https://github.com/projectblacklight/blacklight_advanced_search/pull/71
# Fix label display in search filter constraints ("Filtering by:"), hides URI (was showing "Label$URI")

# Meant to be applied on top of Blacklight view helpers, to over-ride
# certain methods from RenderConstraintsHelper (newish in BL),
# to effect constraints rendering and search history rendering,
BlacklightAdvancedSearch::RenderConstraintsOverride.class_eval do

  # Over-ride of Blacklight method, provide advanced constraints if needed,
  # otherwise call super.
  def render_constraints_filters(my_params = params)
    content = super(my_params)

    if advanced_query
      advanced_query.filters.each_pair do |field, value_list|
        label = facet_field_label(field)
        values = Array(value_list).map { |v| facet_display_value(field, v) }
        content << render_constraint_element(label,
          safe_join(values, " <strong class='text-muted constraint-connector'>OR</strong> ".html_safe),
          :remove => search_action_path(remove_advanced_filter_group(field, my_params).except(:controller, :action))
                                            )
      end
    end

    content
  end
end
