jQuery ->
  $('#myModal').on('shown.bs.modal', ->
    $('#myInput').focus()
  )
  $('#myGeoCoordinatesModal').on('shown.bs.modal', ->
    $('#myInput').focus()
  )


