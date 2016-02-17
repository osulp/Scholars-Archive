jQuery ->
  $('#add_new_geo_type').on("click", (event) ->
    event.preventDefault()
    #Variable assignment and necessary string manipulation
    notice = '<div class="alert alert-info alert-dismissible" role="alert"><button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button> That geotype field already exists </div>'
    type = $('#new_geo_type').val()

    type_string = type_manipulation(type)

    spatial = $(".form-group.generic_file_spatial")
    html = html_manipulation(spatial.clone(), type, type_string)

    html.find("ul.listing li:not(:last-child)").remove()

    #append and managing fields
    $('#geo_wrapper .warning-anchor').append(notice) if $('.generic_file_'+type).length > 0 
    $('#geo_wrapper .group-wrapper').append(html) if $('.generic_file_'+type).length == 0
    $('.form-group.generic_file_'+type).manage_fields()

    html.find('.input-group-btn:first').remove() if html.find('.input-group-btn').length == 2
  )

  html_manipulation = (html, type, type_string) ->
    html.removeClass('generic_file_spatial').addClass('generic_file_'+type)
    html.find('#generic_file_spatial_help').attr('id', 'generic_file_'+type+'_help')
    html.find('input.generic_file_spatial').removeClass('generic_file_spatial').addClass('generic_file_'+type).attr('name', "generic_file["+type+"][]").attr("id", "generic_file_"+type).val('')
    html.find('.geo-header-label').text(type_string)
    html.find('.input-group-btn:last > .add').unbind()
    return html

  type_manipulation = (type) ->
    type_string = type.split("_")[0]
    type_string = type_string.charAt(0).toUpperCase() + type_string.slice(1)

