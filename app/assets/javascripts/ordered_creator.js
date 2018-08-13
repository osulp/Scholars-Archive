function orderedDragAndDrop(selector) {
  selector.nestable({ maxDepth: 0, rootClass: 'ordered-field-container' });
  selector.on('change', function (event) {
    reindexNestedOrderedField();
  });
}

function bindUpDownArrow(mutationsList) {
  $('.ordered-up-arrow').unbind("click").on('click', function(e) {
    swapUp(this);
  });
  $('.ordered-down-arrow').unbind("click").on('click', function(e) {
    swapDown(this);
  });
}

function swapUp(selector) {
  $(selector).parent().insertBefore($(selector).parent().prev());
  reindexNestedOrderedField();
}

function swapDown(selector) {
  $(selector).parent().insertAfter($(selector).parent().next());
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
    var bindObserver = new MutationObserver(bindUpDownArrow);
    nodes.forEach(function (node) {
      reindexObserver.observe(node, config);
      bindObserver.observe(node, config);
    });
  }
});
