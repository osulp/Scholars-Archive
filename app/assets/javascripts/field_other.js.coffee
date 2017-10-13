(($) ->
  Blacklight.onLoad ->
    hide_field = (class_selector) ->
      $(class_selector).addClass("hidden")
      $(class_selector).find('input').attr("type", "hidden")
      $(class_selector).find('input').addClass("hidden")

    show_field = (class_selector) ->
      $(class_selector).removeClass("hidden")
      $(class_selector).find('input').attr("type", "text")
      $(class_selector).find('input').removeClass("hidden")

    load_default_values = () ->
      default_degree_field = $('select.degree-field-selector :selected').val()
      if default_degree_field == "Other"
        show_field('.degree-field-other')
      else
        hide_field('.degree-field-other')

      default_degree_level = $('select.degree-level-selector :selected').val()
      if default_degree_level == "Other"
        show_field('.degree-level-other')
      else
        hide_field('.degree-level-other')

      default_degree_name = $('select.degree-name-selector :selected').val()
      if default_degree_name == "Other"
        show_field('.degree-name-other')
      else
        hide_field('.degree-name-other')

      default_other_affiliation = $('select.other-affiliation-selector').closest('li').find('.other_affiliation_other')
      hide_field(default_other_affiliation)

    load_default_values()

    $('select.degree-field-selector').change ->
      selected = $('select.degree-field-selector :selected').val()
      if selected == "Other"
        show_field('.degree-field-other')
      else
        hide_field('.degree-field-other')

    $('select.degree-level-selector').change ->
      selected = $('select.degree-level-selector :selected').val()
      if selected == "Other"
        show_field('.degree-level-other')
      else
        hide_field('.degree-level-other')

    $('select.degree-name-selector').change ->
      selected = $('select.degree-name-selector :selected').val()
      if selected == "Other"
        show_field('.degree-name-other')
      else
        hide_field('.degree-name-other')

    $(document).on('change', 'select.other-affiliation-selector', (event) ->
      selected = $(this).find(':selected')
      selected_li = $(this).closest('li').find('.other_affiliation_other')
      if selected.val() == "Other"
        show_field(selected_li)
      else
        hide_field(selected_li)
    )
) jQuery

