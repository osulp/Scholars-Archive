(($) ->
  Blacklight.onLoad ->
    hide_field = (class_selector) ->
      $(class_selector).addClass("hidden")
      $(class_selector).find('input').attr("type", "hidden")
      $(class_selector).find('input').addClass("hidden")
      $(class_selector).find('input').removeAttr('required')

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
      values = (append_end_of_str(item.text) for item in options).filter (item) -> item.length > 0
      $(class_selector).find('input').change ->
        constraint = new RegExp('^(?!'+values.join('|')+')(.*)$', "")
        if constraint.test(this.value)
          this.setCustomValidity('')
        else
          this.setCustomValidity('\"' + this.value + '\" already exists, please select from the list.')

    escape_special_chars = (input_str) ->
      return input_str.replace(/\./g, '\\.').replace(/\(/g, '\\(').replace(/\)/g, '\\)')

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

      $('select.degree-field-selector').each (i, element) =>
        degree_field = $(element.closest('li')).find('.degree_field_other')
        if $(element).val() == "Other"
          set_multi_value_validation(degree_field)

      $('select.degree-name-selector').each (i, element) =>
        degree_name = $(element.closest('li')).find('.degree_name_other')
        if $(element).val() == "Other"
          set_multi_value_validation(degree_name)

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
