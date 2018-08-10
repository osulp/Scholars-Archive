function orderedDragAndDrop(selector) {
  selector.nestable({ maxDepth: 0, rootClass: 'ordered-field-container' });
  selector.on('change', function (event) {
    reindexNestedOrderedField();
  });
}

function bindUpDownArrow(mutationsList) {
  $('.ordered-up-arrow').on('click', function(e) {
    $(this).parent().insertBefore($(this).parent().prev());
  });
  $('.ordered-down-arrow').on('click', function(e) {
    $(this).parent().insertAfter($(this).parent().next());
  });
  reindexNestedOrderedField();
}

function reindexNestedOrderedField(mutationsList) {
  hidden_index_selectors = $(".ordered-field-container .index");
  hidden_index_selectors.each(function (index) {
    hidden_index_selectors[index].value = index;
  });
}

Blacklight.onLoad(function () {
  orderedDragAndDrop($('.ordered-field-container'));
  var nodes = document.querySelectorAll('.dd-list');
  if (nodes !== null) {
    var config = { childList: true };
    var reindexObserver = new MutationObserver(reindexNestedOrderedField);
    var upDownObserver = new MutationObserver(bindUpDownArrow);
    nodes.forEach(function (node) {
      reindexObserver.observe(node, config);
      upDownObserver.observe(node, config)
    });
  }
});
