$( document ).ready(function() {
  $('#embargo_reason_select').change(function() {
    var val = $("#embargo_reason_select option:selected").val();
    if (val == 'Other...') {
      $('#article_embargo_reason').removeClass('hidden');
      $('#article_embargo_reason').val("");
    } else {
      $('#article_embargo_reason').addClass('hidden');
      $('#article_embargo_reason').val(val);
    }
  });
  $('input[type="radio"]#article_visibility_embargo').on('change', function(e) {
    $('#embargo_reason_select').val("Intellectual Property (patent, etc.)").trigger('change');
  });
});
