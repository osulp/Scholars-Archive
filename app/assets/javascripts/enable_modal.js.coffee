jQuery ->
  $('#myModal').on('shown.bs.modal', ->
    $('#myInput').focus()
  )

