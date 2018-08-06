function orderedDragAndDrop(selector) {
  selector.nestable({ maxDepth: 0, rootClass: 'ordered-field-container' });
  selector.on('change', function (event) {
    hidden_index_selectors = $(this).find(".index");
    hidden_index_selectors.each(function (index) {
      hidden_index_selectors[index].value = index;
    });
  });
}

function reindexNestedOrderedField() {
  hidden_index_selectors = $($('.ordered-field-container')).find(".index");
  hidden_index_selectors.each(function (index) {
    hidden_index_selectors[index].value = index;
  });
}


Blacklight.onLoad(function () {
  var mycallback = function (mutationsList) {
    alert("buggaboo")
    for (var mutation of mutationsList) {
      if (mutation.type == 'childList') {
        console.log('A child node has been added or removed.');
      }
    }
    hidden_index_selectors = $($('.ordered-field-container')).find(".index");
    hidden_index_selectors.each(function (index) {
      hidden_index_selectors[index].value = index;
    });
  };

  orderedDragAndDrop($('.ordered-field-container'));

  var nodes = document.querySelectorAll('.dd-list');
  if (nodes !== null) {
    var config = { childList: true };
    var observer = new MutationObserver(mycallback);
    nodes.forEach(function (node) {
      observer.observe(node, config);
    });
  }
});
