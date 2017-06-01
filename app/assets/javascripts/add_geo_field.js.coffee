jQuery ->
  toggle_header = (row_count) ->
    if (row_count == 0)
      $('#geo_fields table thead tr').addClass('hidden')
    else
      $('#geo_fields table thead tr').removeClass('hidden')

  # hide table header if empty
  row_count = $('#geo_fields table tbody tr:visible').length
  toggle_header(row_count)

  # function to remove geo field
  $(document).on("click", '#geo_wrapper button.remove_geo_type', (event) ->
    selected_geo = $(this).attr("data-id")
    $('tr.'+selected_geo+' button.remove_entry').click()
    hide_remove(selected_geo)
    event.preventDefault()
    event.stopPropagation()
  )

  hide_remove = (term) ->
    if ($('#geo_fields .'+term+' ul.listing li:visible').length == 1)
      $('#geo_fields .'+term+' ul.listing button.remove_entry').addClass('hidden')

  # function to add new date field

  $('#new_geo_type').change ->
    selected_geo = $('#new_geo_type :selected').val()
    geo_field = $(this).data(selected_geo.replace(new RegExp('_', 'g'),'-'))
    $('tr.geo_field.'+selected_geo).remove()
    $('#geo_fields table tbody').prepend(geo_field)
    $('#geo_fields table tbody tr.geo_field.'+selected_geo+' input').val("")
    $('#new_geo_type option[value='+selected_geo+']').remove()

    # hide table header if empty
    row_count = $('#geo_fields table tbody tr:visible').length
    toggle_header(row_count)
    hide_remove(selected_geo)

  $('#geo_fields').on 'click', 'button.remove_entry', (event) ->
    $(this).prev('input[type=hidden]').val('1')
    $(this).closest('fieldset').hide()
    selected_geo = $(this).attr("data-id")
    hide_remove(selected_geo)
    event.preventDefault()

  $('#geo_fields').on 'click', 'button.add_entry', (event) ->
    time = new Date().getTime()
    selected = $(this).attr("data-id")
    term = $(this).attr("data-term")
    regexp = new RegExp($('#new_geo_type').data(selected+'-id'), 'g')
    $(this).before($('#new_geo_type').data(selected).replace(regexp, time))
    $('#geo_fields .'+term+' ul.listing button.remove_entry').removeClass('hidden')
    event.preventDefault()

