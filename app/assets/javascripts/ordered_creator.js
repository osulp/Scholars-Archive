function orderedDragAndDrop(selector) {
  selector.nestable({ maxDepth: 0, rootClass: 'ordered-field-container' });
  selector.on('change', function (event) {
    reindexNestedOrderedField();
  });
}

function bindUpDownArrow(mutationsList) {
  $('button.up-arrow').prop('disabled',false).unbind("click").on('click', function(e) {
    swapUp($(this).parent());
  });
  $('button.down-arrow').prop('disabled',false).unbind("click").on('click', function(e) {
    swapDown($(this).parent());
  });
  $('ul.draggable-order > li:first-child button.up-arrow').prop('disabled',true);
  $('ul.draggable-order > li:last-child button.down-arrow').prop('disabled',true);
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
  hidden_index_selectors = $(".nested-ordered-creator .index");
  hidden_index_selectors.each(function (index) {
    hidden_index_selectors[index].value = index;
  });
  hidden_index_selectors = $(".nested-ordered-title .index");
  hidden_index_selectors.each(function (index) {
    hidden_index_selectors[index].value = index;
  });
  hidden_index_selectors = $(".nested-ordered-related-items .index");
  hidden_index_selectors.each(function (index) {
    hidden_index_selectors[index].value = index;
  });
  hidden_index_selectors = $(".nested-ordered-abstract .index");
  hidden_index_selectors.each(function (index) {
    hidden_index_selectors[index].value = index;
  });
  hidden_index_selectors = $(".nested-ordered-alt-title .index");
  hidden_index_selectors.each(function (index) {
    hidden_index_selectors[index].value = index;
  });
  hidden_index_selectors = $(".nested-ordered-contributor .index");
  hidden_index_selectors.each(function (index) {
    hidden_index_selectors[index].value = index;
  });
  hidden_index_selectors = $(".nested-ordered-description .index");
  hidden_index_selectors.each(function (index) {
    hidden_index_selectors[index].value = index;
  });
  hidden_index_selectors = $(".nested-ordered-editor .index");
  hidden_index_selectors.each(function (index) {
    hidden_index_selectors[index].value = index;
  });
  hidden_index_selectors = $(".nested-ordered-tableofcontents .index");
  hidden_index_selectors.each(function (index) {
    hidden_index_selectors[index].value = index;
  });
  hidden_index_selectors = $(".nested-ordered-typical-age-range .index");
  hidden_index_selectors.each(function (index) {
    hidden_index_selectors[index].value = index;
  });
}

Blacklight.onLoad(function () {
  orderedDragAndDrop($('.nested-ordered-related-items'));
  orderedDragAndDrop($('.nested-ordered-title'));
  orderedDragAndDrop($('.nested-ordered-creator'));
  orderedDragAndDrop($('.nested-ordered-abstract'));
  orderedDragAndDrop($('.nested-ordered-alt-title'));
  orderedDragAndDrop($('.nested-ordered-contributor'));
  orderedDragAndDrop($('.nested-ordered-description'));
  orderedDragAndDrop($('.nested-ordered-editor'));
  orderedDragAndDrop($('.nested-ordered-tableofcontents'));
  orderedDragAndDrop($('.nested-ordered-typical-age-range'));


  var nodes = document.querySelectorAll('.dd-list');
  if (nodes !== null) {
    var config = { childList: true };
    var reindexObserver = new MutationObserver(reindexNestedOrderedField);
    var bindObserver = new MutationObserver(bindUpDownArrow);
    nodes.forEach(function (node) {
      reindexObserver.observe(node, config);
      bindObserver.observe(node, config);
    });
    bindUpDownArrow();
  }
});
