Blacklight.onLoad(function() {
  $('#embargo_reason_select').change(function() {
    var val = $("#embargo_reason_select option:selected").val();
    if (val == 'Other...') {
      $('[id$=embargo_reason]').removeClass('d-none');
      $('[id$=embargo_reason]').val("");
    } else {
      $('[id$=embargo_reason]').addClass('d-none');
      $('[id$=embargo_reason]').val(val);
    }
  });
  $('input[type="radio"][id$=visibility_embargo]').on('change', function(e) {
    $('#embargo_reason_select').val("Intellectual Property (patent, etc.)").trigger('change');
  });
  $('input[type="radio"][name$="[visibility]"]').on('change', function(e) {
    // Set embargo options disabled if we're not on embargo, enabled if we are
    $('[name$="[embargo_release_date]"').prop('disabled', $(this).val() != 'embargo')
    $('[name$="[embargo_reason]"').prop('disabled', $(this).val() != 'embargo')
  });
});
