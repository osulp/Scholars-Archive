jQuery ->
  switch_button = $("<button type='button' class='btn switch-fields'><span class='glyphicon glyphicon-random'></span></button>")
  switch_button.prependTo($("input.uri_multi_value:not([name])").siblings(".field-controls"))
  $(".switch-fields").click ->
    $(this).parent().siblings("input").toggleClass("hidden")
