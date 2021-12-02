$(document).ready(function () {
  $('input.required').each(function(){
    $(this).keyup(function(){
      numEmpty = $('input.required').filter(function () {
        return $.trim($(this).val()).length == 0
      }).length

      if (numEmpty > 0) {
	      $('#with_files_submit').attr("disabled","disabled");
      }
    });
  });
});