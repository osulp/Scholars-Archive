jQuery ->
  $(".geo_bbox").hide() if $("#generic-file-location-form .geo_bbox ul.listing li > .form-group").hasClass("generic_file_nested_geo_bbox_id") is false
  $(".geo_point").hide() if $("#generic-file-location-form .geo_point ul.listing li > .form-group").hasClass("generic_file_nested_geo_point_id") is false
  $('#add_new_geo_type').on("click", (event) ->
    event.preventDefault()
    type = $('#new_geo_type').val()
    $(".geo_"+type).show()

  )

