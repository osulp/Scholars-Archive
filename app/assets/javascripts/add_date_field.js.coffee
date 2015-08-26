jQuery ->
  # $(".nested-field").manage_fields()
  $('#add_new_date_type').on("click", (event) ->
    event.preventDefault()
    type = $('#new_date_type').val()
    # html = $("<div />").append($(".generic_file_date_created").clone())

    html = $(".generic_file_date_created").clone()
    alert(html.html())
    html.removeClass('generic_file_date_created').addClass('generic_file_'+type)
    # html.children('input').removeClass('generic_file_date_created').addClass('generic_file_'+type)
    html.find("input.generic_file_date_created").removeClass('generic_file_date_created').addClass('generic_file_'+type).attr('id', 'generic_file_'+type).attr('name', 'generic_file['+type+'][]')
    $('#date_wrapper').append(html)
    alert(html.html())
  )

