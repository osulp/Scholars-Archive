jQuery ->
  $(".geo_bbox").hide() if $("#generic-work-location-form .geo_bbox ul.listing li > .form-group").hasClass("generic_work_nested_geo_bbox_id") is false
  $(".geo_point").hide() if $("#generic-work-location-form .geo_point ul.listing li > .form-group").hasClass("generic_work_nested_geo_points_id") is false
  $(".geo_location").hide() if $("#generic-work-location-form .geo_location ul.listing li > .form-group").hasClass("generic_work_nested_geo_location_id") is false
  $('#add_new_geo_type').on("click", (event) ->
    event.preventDefault()
    type = $('#new_geo_type').val()
    $(".geo_"+type).show()

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

