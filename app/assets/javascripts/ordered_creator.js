function orderedDragAndDrop(selector) {
  selector.nestable({maxDepth: 0, rootClass: 'ordered-field-container'});
  selector.on('change', function(event) {
    // Scope to a container because we may have two orderable sections on the page
  });
}
Blacklight.onLoad(function() {
  orderedDragAndDrop($('.ordered-field-container'));
});
