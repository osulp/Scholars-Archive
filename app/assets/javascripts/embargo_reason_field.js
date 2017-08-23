$( document ).ready(function() {
  $('#embargo_reason_select').change(function() {
    var val = $("#embargo_reason_select option:selected").val();
    if (val == 'Other...') {
      $('[id$=embargo_reason]').removeClass('hidden');
      $('[id$=embargo_reason]').val("");
    } else {
      $('[id$=embargo_reason]').addClass('hidden');
      $('[id$=embargo_reason]').val(val);
    }
  });
  $('input[type="radio"][id$=visibility_embargo]').on('change', function(e) {
    $('#embargo_reason_select').val("Intellectual Property (patent, etc.)").trigger('change');
  });
});
