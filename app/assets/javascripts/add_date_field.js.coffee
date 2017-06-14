jQuery ->
  date_default = () ->
    $('#date_wrapper .date-default .date-input input').datetimepicker({
      timepicker:false,
      format:'Y-m-d',
      scrollMonth: false,
      scrollTime: false,
      scrollInput: false,
      validateOnBlur: false
    })

  date_default()

  date_range = (term) ->
    term_start_id = '#timepicker_start_'+term
    term_end_id = '#timepicker_end_'+term
    term_range_id = '#timepicker_range_'+term
    work_type = $('#new_date_type').data('work-type')
    $(term_start_id).datetimepicker({
      format:'Y-m-d',
      onShow: ( ct ) ->
        this.setOptions({
          maxDate: if $(term_end_id).val().length > 0 then $(term_end_id).val() else false,
          formatDate:'Y-m-d',
        })
      ,
      timepicker:false,
      scrollMonth: false,
      scrollTime: false,
      scrollInput: false,
      validateOnBlur: false,
      onChangeDateTime:(ct,$i) ->
        range = $i.val() + '/' + $(term_end_id).val()
        work_type = $('#new_date_type').data('work-type')
        $(term_range_id).text(range)
        $('#'+work_type+'_'+term).val(range)
    })
    $(term_end_id).datetimepicker({
      format:'Y-m-d',
      onShow: ( ct ) ->
        this.setOptions({
          minDate: if $(term_start_id).val().length > 0 then $(term_start_id).val() else false,
          formatDate:'Y-m-d',
        })
      ,
      timepicker:false,
      scrollMonth: false,
      scrollTime: false,
      scrollInput: false,
      validateOnBlur: false,
      onChangeDateTime:(ct,$i) ->
        range = $(term_start_id).val() + '/' + $i.val()
        work_type = $('#new_date_type').data('work-type')
        $(term_range_id).text(range)
        $('#'+work_type+'_'+term).val(range)

    })
    $(term_range_id).text($('#'+work_type+'_'+term).val())

  $('#date_fields tr.date-range').each (i, element) =>
    date_id = $(element).attr("data-id")
    date_range(date_id)

  toggle_header = (row_count) ->
    if (row_count == 0)
      $('#date_fields table thead tr').addClass('hidden')
    else
      $('#date_fields table thead tr').removeClass('hidden')

  # hide table header if empty
  row_count = $('#date_fields table tbody tr:visible').length
  toggle_header(row_count)

  $(document).on("click", '.calendar_start', (event) ->
    selected_date = $(this).attr("data-id")
    $('#timepicker_start_'+selected_date).datetimepicker('show')
  )

  $(document).on("click", '.calendar_end', (event) ->
    selected_date = $(this).attr("data-id")
    $('#timepicker_end_'+selected_date).datetimepicker('show')
  )

  $(document).on("change", 'input.toggle_date_range', (event) ->
    selected_date = $(this).attr("data-id")
    if ($(this).is(':checked'))
      data_range = $('#new_date_type').data('range-'+selected_date.replace('_','-'))
      $('#date_field_inputs_'+selected_date+' .date-range-inputs').empty().append(data_range)
      $('#date_field_inputs_'+selected_date+' .date-input').removeClass("date-default")
      $('#date_field_inputs_'+selected_date+' .date-input').addClass("date-range")
      date_range(selected_date)
      $('#date_fields tr.'+selected_date+' button.remove_date_type').addClass('date-range')
      $('#date_fields tr.'+selected_date+' button.remove_date_type').removeClass('date-default')

      $('#date_field_inputs_'+selected_date+' .date-input input').datetimepicker('destroy')
      $('#date_field_inputs_'+selected_date+' .date-input input').attr("placeholder", "Date range")
    else
      $('#date_field_inputs_'+selected_date+' .date-range-inputs').empty()
      $('#date_field_inputs_'+selected_date+' .date-input').removeClass("date-range")
      $('#date_field_inputs_'+selected_date+' .date-input').addClass("date-default")
      date_default()

      $('#date_fields tr.'+selected_date+' button.remove_date_type').addClass('date-default')
      $('#date_fields tr.'+selected_date+' button.remove_date_type').removeClass('date-range')

      $('#date_field_inputs_'+selected_date+' .date-input input').attr("placeholder", "YYYY-mm-dd")
    $('#date_fields table tbody tr.date_field.'+selected_date+' .date-input input').val("")
  )

  # function to remove date field
  $(document).on("click", '#date_wrapper button.remove_date_type', (event) ->
    selected_date = $(this).attr("data-id")
    selected_date_label = $('#date_fields table tbody tr.date_field.'+selected_date+' label.control-label').text()
    # add the option to be deleted back to the select box
    $('#new_date_type').append($('<option>', {value: selected_date, text: selected_date_label}))

    # sort options
    default_option_label = $('#new_date_type option[value=default_option').text()
    $('#new_date_type option[value=default_option]').remove()
    options = $('#new_date_type option')

    options.sort (a, b) ->
      if (a.text > b.text)
        return 1
      else if (a.text < b.text)
        return -1
      else
        return 0

    $('#new_date_type').empty().append(options)
    default_option = $('<option>', { value: 'default_option', text: default_option_label })
    $('#new_date_type').prepend(default_option)
    $('#new_date_type option[value=default_option').prop('selected', true)

    # clear the input text in the selected date field (this is needed to
    # properly update the value on submit)
    $('#date_fields tr.date_field.'+selected_date+' .date-input input').val("")

    # hide the date field
    $('tr.date_field.'+selected_date).addClass('hidden')

    # hide table header if empty
    row_count = $('#date_fields table tbody tr:visible').length
    toggle_header(row_count)

    event.preventDefault()
    event.stopPropagation()
  )

  # function to add new date field

  $('#new_date_type').change ->
    selected_date = $('#new_date_type :selected').val()
    date_field = $(this).data(selected_date.replace('_','-'))
    $('tr.date_field.'+selected_date).remove()
    $('#date_fields table tbody').prepend(date_field)
    $('#date_fields table tbody tr.date_field.'+selected_date+' input').val("")
    $('#new_date_type option[value='+selected_date+']').remove()

    # hide table header if empty
    row_count = $('#date_fields table tbody tr:visible').length
    toggle_header(row_count)

    date_default()
    date_range(selected_date)
