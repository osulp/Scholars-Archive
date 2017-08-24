$(document).on('ready turbolinks:load', function() {
  $('[id$=embargo_release_date].datepicker').datepicker({dateFormat:"yy-mm-dd"});
  $('#embargo_date_select').change(function() {
    var val = $("#embargo_date_select option:selected").val();
    if (val == 'other') {
      $('[id$=embargo_release_date]').removeClass('hidden');
    } else {
      date = new Date(parseInt(val.split("-")[0]),parseInt(val.split("-")[1]),parseInt(val.split("-")[2]))
      $('[id$=embargo_release_date]').addClass('hidden');
      $('[id$=embargo_release_date].datepicker').datepicker('setDate', date);
    }
  });
});
