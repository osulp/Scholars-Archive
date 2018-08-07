function orderedDragAndDrop(selector) {
  selector.nestable({ maxDepth: 0, rootClass: 'ordered-field-container' });
  selector.on('change', function (event) {
    reindexNestedOrderedField();
  });
}

function reindexNestedOrderedField(mutationsList) {
  hidden_index_selectors = $($(".ordered-field-container .index"));
  hidden_index_selectors.each(function (index) {
    hidden_index_selectors[index].value = index;
  });
}

Blacklight.onLoad(function () {
  orderedDragAndDrop($('.ordered-field-container'));
  var nodes = document.querySelectorAll('.dd-list');
  if (nodes !== null) {
    var config = { childList: true };
    var observer = new MutationObserver(reindexNestedOrderedField);
    nodes.forEach(function (node) {
      observer.observe(node, config);
    });
  }
});
