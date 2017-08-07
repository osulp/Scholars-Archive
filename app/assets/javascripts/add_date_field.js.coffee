(($) ->
  Blacklight.onLoad ->
    date_default = (selector) ->
      selector.datetimepicker({
        timepicker:false,
        format:'Y-m-d',
        scrollMonth: false,
        scrollTime: false,
        scrollInput: false,
        validateOnBlur: false
      })

    date_default($('#date_wrapper .date-default.date-input input'))

    date_range = (start_date, end_date, target_input) ->
      $(start_date).datetimepicker({
        format:'Y-m-d',
        onShow: ( ct ) ->
          this.setOptions({
            maxDate: if $(end_date).val().length > 0 then $(end_date).val() else false,
            formatDate:'Y-m-d',
          })
        ,
        timepicker:false,
        scrollMonth: false,
        scrollTime: false,
        scrollInput: false,
        validateOnBlur: false,
        onChangeDateTime:(ct,$i) ->
          range = $i.val() + '/' + $(end_date).val()
          $(target_input).val(range)
      })
      $(end_date).datetimepicker({
        format:'Y-m-d',
        onShow: ( ct ) ->
          this.setOptions({
            minDate: if $(start_date).val().length > 0 then $(start_date).val() else false,
            formatDate:'Y-m-d',
          })
        ,
        timepicker:false,
        scrollMonth: false,
        scrollTime: false,
        scrollInput: false,
        validateOnBlur: false,
        onChangeDateTime:(ct,$i) ->
          range = $(start_date).val() + '/' + $i.val()
          $(target_input).val(range)
      })


    date_range_multiple = (target) ->
      term = $(target).attr("data-term")
      start_date = $(target).find('input.timepicker_start')
      end_date = $(target).find('input.timepicker_end')
      target_input = $(target).find('input.multi_value')
      date_range(start_date, end_date, target_input)

    # date-range defaults for single value dates
    $('#date_fields tr.date-range').each (i, element) =>
      date_id = $(element).attr("data-id")
      start_date = '#timepicker_start_'+date_id
      end_date = '#timepicker_end_'+date_id
      work_type = $('#new_date_type').data('work-type')
      date_range(start_date, end_date, '#'+work_type+'_'+date_id)

    # date-range defaults for multiple value dates
    $('#date_fields tr.date-multiple .date_inputs').each (i, element) =>
      date_range_multiple(element)

    toggle_header = (row_count) ->
      if (row_count == 0)
        $('#date_fields table thead tr').addClass('hidden')
      else
        $('#date_fields table thead tr').removeClass('hidden')

    # hide table header if empty
    row_count = $('#date_fields table tbody tr:visible').length
    toggle_header(row_count)

    $(document).on("click", '.calendar_start', (event) ->
      target = this.closest('div.input-group')
      $(target).find('input.timepicker_start').datetimepicker('show')
    )

    $(document).on("click", '.calendar_end', (event) ->
      target = this.closest('div.input-group')
      $(target).find('input.timepicker_end').datetimepicker('show')
    )

    hide_calendar_widget_multiple = (term, inputs_selector) ->
      data_range = $('#new_date_type').data('range-'+term.replace('_','-'))
      date_listing = $('tr.'+term).find("ul.listing .field-wrapper")
      # remove widget
      inputs = date_listing.find(inputs_selector+' .date-range-inputs')
      $(inputs).empty()
      # update class in date input wrapper
      date_input = date_listing.find(inputs_selector+' .date-input')
      $(date_input).removeClass("date-range")
      $(date_input).addClass("date-default")
      # update placeholder in date input
      input = date_listing.find(inputs_selector+' .date-input input')
      $(input).val('')
      $(input).datetimepicker('destroy')
      $(input).attr("placeholder", "YYYY-mm-dd")
      date_default($(inputs_selector).find('.date-input.date-default input.multi_value'))

    show_calendar_widget_multiple = (term, inputs_selector) ->
      data_range = $('#new_date_type').data('range-'+term.replace('_','-'))
      date_listing = $('tr.'+term).find("ul.listing .field-wrapper")
      # append widget
      inputs = date_listing.find(inputs_selector+' .date-range-inputs')
      $(inputs).empty().append(data_range)
      # update class in date input wrapper
      date_input = date_listing.find(inputs_selector+' .date-input')
      $(date_input).removeClass("date-default")
      $(date_input).addClass("date-range")
      # update placeholder in date input
      input = date_listing.find(inputs_selector+' .date-input input')
      $(input).val('')
      $(input).datetimepicker('destroy')
      $(input).attr("placeholder", "Date range")
      date_range_multiple(inputs_selector)

    $(document).on("change", 'input.toggle_date_range', (event) ->
      selected_date = $(this).attr("data-id")
      if ($(this).is(':checked'))
        if $(this).hasClass('form-check-multiple-input')
          show_calendar_widget_multiple($(this).attr("data-term"), '#date_field_inputs_'+selected_date)
        else
          data_range = $('#new_date_type').data('range-'+selected_date.replace('_','-'))
          $('#date_field_inputs_'+selected_date+' .date-range-inputs').empty().append(data_range)

          $('#date_field_inputs_'+selected_date+' .date-input').removeClass("date-default")
          $('#date_field_inputs_'+selected_date+' .date-input').addClass("date-range")

          start_date = '#timepicker_start_'+selected_date
          end_date = '#timepicker_end_'+selected_date
          work_type = $('#new_date_type').data('work-type')
          date_range(start_date, end_date, '#'+work_type+'_'+selected_date)
          $('#date_fields tr.'+selected_date+' button.remove_date_type').addClass('date-range')
          $('#date_fields tr.'+selected_date+' button.remove_date_type').removeClass('date-default')

          $('#date_field_inputs_'+selected_date+' .date-input input').datetimepicker('destroy')
          $('#date_field_inputs_'+selected_date+' .date-input input').attr("placeholder", "Date range")
      else
        if $(this).hasClass('form-check-multiple-input')
          hide_calendar_widget_multiple($(this).attr("data-term"), '#date_field_inputs_'+selected_date)
        else
          $('#date_field_inputs_'+selected_date+' .date-range-inputs').empty()
          $('#date_field_inputs_'+selected_date+' .date-input').removeClass("date-range")
          $('#date_field_inputs_'+selected_date+' .date-input').addClass("date-default")

          date_default($('#date_wrapper .date-default.date-input input'))

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

      if ($('#new_date_type').find('option[value="'+selected_date+'"]').length == 0)
        $('#new_date_type').append($('<option>', {value: selected_date, text: selected_date_label}))

      # sort options
      default_option_label = $('#new_date_type option[value=default_option]').text()
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
      $('#new_date_type option[value=default_option]').prop('selected', true)

      # clear the input text in the selected date field (this is needed to
      # properly update the value on submit)
      $('#date_fields tr.date_field.'+selected_date+' .date-input input').val("")

      # hide the date field
      $('tr.date_field.'+selected_date).addClass('hidden')

      # hide table header if empty
      row_count = $('#date_fields table tbody tr:visible').length
      toggle_header(row_count)

      event.stopPropagation()
      event.preventDefault()
    )

    # function to add new date field
    $('#new_date_type').change ->
      selected_date = $('#new_date_type :selected').val()

      date_field = $('#new_date_type').data(selected_date.replace('_','-'))
      $('tr.date_field.'+selected_date).remove()
      $('#date_fields table tbody').prepend(date_field)
      $('#date_fields table tbody tr.date_field.'+selected_date+' input').val("")

      $('#new_date_type option[value='+selected_date+']').remove()

      # hide table header if empty
      row_count = $('#date_fields table tbody tr:visible').length
      toggle_header(row_count)

      date_default($('#date_wrapper .date-default.date-input input'))

      start_date = '#timepicker_start_'+selected_date
      end_date = '#timepicker_end_'+selected_date
      work_type = $('#new_date_type').data('work-type')
      $('.multi_value.form-group').manage_fields()
      date_range(start_date, end_date, '#'+work_type+'_'+selected_date)

    update_toggle_id = (selector, new_index) ->
      new_id = 'toggle_date_range_'+new_index
      new_toggle_range = selector.find("input.form-check-multiple-input")
      term = new_toggle_range.attr('data-term')
      new_toggle_range.attr('name', new_id)
      new_toggle_range.attr('id', new_id)
      new_toggle_range.attr('data-id', term+'_'+new_index)
      new_toggle_range.attr('data-index', new_index)
      new_toggle_range_label = selector.find("label.form_check_label")
      new_label_id = 'toggle_date_range_'+new_index+'_label'
      new_toggle_range_label.attr('name', new_label_id)
      new_toggle_range_label.attr('for', new_id)

    update_date_inner_wrapper = (selector, new_index) ->
      new_inner = selector.find(".date_inputs")
      term = $(new_inner).attr("data-term")
      new_id = 'date_field_inputs_'+term+'_'+new_index
      new_inner.attr('id', new_id)

    $(document).on("managed_field:add", '.multi_value_date.form-group', (event) ->
      window.setTimeout(->
        new_date = $(event.target).find("ul.listing .field-wrapper").last()
        # update ids to manage date range checkboxes
        new_index = new Date().getTime() # use current time to make sure the new id is unique
        update_toggle_id(new_date, new_index)
        # update date_field_inputs inner wrapper for a single date
        update_date_inner_wrapper(new_date, new_index)
        inputs_selector = '#date_field_inputs_' + $(new_date.find(".date_inputs")).attr('data-term') + '_'+new_index
        $(inputs_selector).find('.date-input input.multi_value').val('')
        # bind the calendar to the new input values
        if (new_date.find('.date-input').hasClass('date-range'))
          date_range_multiple(inputs_selector)
          $(inputs_selector).find('.date-range-inputs input').val('')
        else
          date_default(new_date.find(".date-default input.multi_value"))

      , 15)
    )

    $(document).on("managed_field:remove", '.multi_value_date.form-group', (event, removed) ->
      new_date = $(event.target).find("ul.listing .field-wrapper").last()
      $(new_date.find("input.form-check-multiple-input")).focus()
      event.preventDefault()
      event.stopPropagation()
    )
) jQuery
