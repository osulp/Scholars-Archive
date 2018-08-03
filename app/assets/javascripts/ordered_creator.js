function orderedDragAndDrop(selector) {
  selector.nestable({maxDepth: 0, rootClass: 'ordered-field-container'});
  selector.on('change', function(event) {
    hidden_index_selectors = $(this).find(".index");
    hidden_index_selectors.each(function( index ) {
      hidden_index_selectors[index].value = index;
    });
  });
}
Blacklight.onLoad(function() {
  orderedDragAndDrop($('.ordered-field-container'));
});
