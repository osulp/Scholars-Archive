$(document).ready(function() {
  $('[id^="add-subcollection-modal-"]').find('.modal-add-button').on('click', function (e) {
    $(this).prop('disabled', true);
    alert("This action is being processed in the backgroud.");
    $('[id^="add-subcollection-modal-"]').modal('hide');
  });
  $('[id="collection-remove-subcollection-modal"]').find('.modal-button-remove-collection').on('click', function (e) {
    $(this).prop('disabled', true);
    alert("This action is being processed in the backgroud.");
    $('[id="collection-remove-subcollection-modal"]').modal('hide');
  });
});
