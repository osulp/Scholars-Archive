jQuery ->
  hide_field = (class_selector) ->
    $(class_selector).addClass("hidden")
    $(class_selector+' input').attr("type", "hidden")
    $(class_selector+' input').addClass("hidden")

  show_field = (class_selector) ->
    $(class_selector).removeClass("hidden")
    $(class_selector+' input').attr("type", "text")
    $(class_selector+' input').removeClass("hidden")


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
