$(document).ready(function () {
  $('.required').each(function(){
    $(this).keyup(function(){
      if ($(this).is(":focus")&& $(this).val() == "") {
	$('#with_files_submit').attr("disabled","disabled");
      }
    });
  });
});