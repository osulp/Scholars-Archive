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

  nested_fields = ['.nested-ordered-creator .index', 
                     '.nested-ordered-title .index', 
                     '.nested-ordered-abstract .index', 
                     '.nested-ordered-contributor .index', 
                     '.nested-ordered-additional-information .index', 
                     '.nested-ordered-related-items .index']

  for (element in nested_fields) {
    selectors = $(nested_fields[element]);
    selectors.each(function (index) {
      selectors[index].value = index;
    });
  }
}

Blacklight.onLoad(function () {

  nested_fields = ['.nested-ordered-creator', 
                     '.nested-ordered-title', 
                     '.nested-ordered-abstract', 
                     '.nested-ordered-contributor', 
                     '.nested-ordered-additional-information', 
                     '.nested-ordered-related-items']

  for (element in nested_fields) {
    orderedDragAndDrop($(nested_fields[element]));
  }

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
