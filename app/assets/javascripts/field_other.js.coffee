(($) ->
  Blacklight.onLoad ->
    hide_field = (class_selector) ->
      $(class_selector).addClass("hidden")
      $(class_selector).find('input').attr("type", "hidden")
      $(class_selector).find('input').addClass("hidden")
      $(class_selector).find('input').removeAttr('required')
      $(class_selector).find('input').parent().removeClass('has-error')
      $(class_selector).find('.help-block').text('')

    show_field = (class_selector) ->
      $(class_selector).removeClass("hidden")
      $(class_selector).find('input').attr("type", "text")
      $(class_selector).find('input').removeClass("hidden")
      $(class_selector).find('input').attr('required', 'required')

    set_single_value_validation = (class_selector) ->
      options = $(class_selector).prev().find('select option')
      set_validation(options, class_selector)

    set_multi_value_validation = (class_selector) ->
      options = $(class_selector).prev()[0].options
      set_validation(options, class_selector)

    set_validation = (options, class_selector) ->
      form  = document.getElementsByTagName('form')[0]
      input = $(class_selector).find('input')[0]
      display = (e) ->
        values = (append_end_of_str(item.text) for item in options).filter (item) -> item.length > 0
        prepend_help_block(class_selector)
        constraint = new RegExp('^(?!'+values.join('|')+')(.*)$', "")
        if constraint.test(input.value)
          clear_error(class_selector)
        else
          set_error(e, input.value, class_selector)

      form.addEventListener 'submit', display, false

    set_error = (e, input_value, class_selector) ->
      cancel_save(e)
      $(class_selector).find('input').parent().addClass('has-error')
      $(class_selector).find('.help-block').text('"'+ input_value + '" already exists, please select from the list.')
      $(class_selector).closest('.form-group')[0].scrollIntoView(true)
      return false

    clear_error = (class_selector) ->
      $('.multi_value.form-group').manage_fields()
      $(class_selector).find('input').parent().removeClass('has-error')
      $(class_selector).find('.help-block').text('')

    cancel_save = (e) ->
      e.preventDefault()
      e.stopPropagation()
      $("#form-progress .panel-footer:first").removeClass("hidden").find("input.btn-primary").attr("disabled", false)
      $("#form-progress .panel-footer:last").addClass("hidden")

    escape_special_chars = (input_str) ->
      return input_str.replace(/\./g, '\\.').replace(/\(/g, '\\(').replace(/\)/g, '\\)')

    prepend_help_block = (class_selector) ->
      $(class_selector).find('.help-block').remove() if $(class_selector).find('.help-block').length > 0
      $(class_selector).prepend('<div class="help-block"></div>')

    append_end_of_str = (input_str) ->
      if input_str.length > 0
        return escape_special_chars(input_str) + '$'
      else
        return input_str

    load_default_values = () ->
      default_degree_level = $('select.degree-level-selector :selected').val()
      if default_degree_level == "Other"
        show_field('.degree-level-other')
      else
        hide_field('.degree-level-other')

      default_degree_grantors = $('select.degree-grantors-selector :selected').val()
      if default_degree_grantors == "Other"
        show_field('.degree-grantors-other')
      else
        hide_field('.degree-grantors-other')

      $('select.other-affiliation-selector').each (i, element) =>
        default_other_affiliation = $(element.closest('li')).find('.other_affiliation_other')
        if $(element).val() == "Other"
          show_field(default_other_affiliation)
        else
          hide_field(default_other_affiliation)

    load_default_values()

    $('select.degree-level-selector').change ->
      selected = $('select.degree-level-selector :selected').val()
      $('.degree-level-other').find('input').val("")
      if selected == "Other"
        show_field('.degree-level-other')
        set_single_value_validation('.degree-level-other')
      else
        hide_field('.degree-level-other')

    $('select.degree-grantors-selector').change ->
      selected = $('select.degree-grantors-selector :selected').val()
      $('.degree-grantors-other').find('input').val("")
      if selected == "Other"
        show_field('.degree-grantors-other')
        set_single_value_validation('.degree-grantors-other')
      else
        hide_field('.degree-grantors-other')

    $(document).on('change', 'select.degree-field-selector', (event) ->
      selected = $(this).find(':selected')
      selected_li = $(this).closest('li').find('.degree_field_other')
      $(selected_li).find('input').val("")
      if selected.val() == "Other"
        show_field(selected_li)
        set_multi_value_validation(selected_li)
      else
        hide_field(selected_li)
    )

    $(document).on('change', 'select.degree-name-selector', (event) ->
      selected = $(this).find(':selected')
      selected_li = $(this).closest('li').find('.degree_name_other')
      $(selected_li).find('input').val("")
      if selected.val() == "Other"
        show_field(selected_li)
        set_multi_value_validation(selected_li)
      else
        hide_field(selected_li)
    )

    $(document).on('change', 'select.other-affiliation-selector', (event) ->
      selected = $(this).find(':selected')
      selected_li = $(this).closest('li').find('.other_affiliation_other')
      $(selected_li).find('input').val("")
      if selected.val() == "Other"
        show_field(selected_li)
        set_multi_value_validation(selected_li)
      else
        hide_field(selected_li)
    )
) jQuery
