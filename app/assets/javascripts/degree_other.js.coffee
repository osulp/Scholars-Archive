(($) ->
  Blacklight.onLoad ->
    hide_field = (class_selector) ->
      $(class_selector).addClass("hidden")
      $(class_selector+' input').attr("type", "hidden")
      $(class_selector+' input').addClass("hidden")

    show_field = (class_selector) ->
      $(class_selector).removeClass("hidden")
      $(class_selector+' input').attr("type", "text")
      $(class_selector+' input').removeClass("hidden")

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
) jQuery

