Blacklight.onLoad(function() {
  $('[id$=embargo_release_date].datepicker').datepicker({dateFormat:"yy-mm-dd"});
  $('#embargo_date_select').change(function() {
    var val = $("#embargo_date_select option:selected").val();
    if (val == 'other') {
      $('[id$=embargo_release_date]').removeClass('d-none');
      $('.date_picker_wrapper ').removeClass('d-none');
      $('[id$=embargo_release_date]').val('');
    } else {
      date = new Date(parseInt(val.split("-")[0]),parseInt(val.split("-")[1]),parseInt(val.split("-")[2]))
      $('[id$=embargo_release_date]').addClass('d-none');
      $('.date_picker_wrapper ').addClass('d-none');
      $('[id$=embargo_release_date].datepicker').datepicker('setDate', date);
    }
  });
});
