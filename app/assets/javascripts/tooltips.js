Blacklight.onLoad(function() {
  var search_options = {
    placement: 'top',
    title: 'Visit external link'
  };
  var more_information = {
    placement: 'top',
    title: 'More information about this item'
  };

  $('.metadata > .table a').not('.btn').tooltip(search_options);
  $('li.attribute a').not('.btn').not('[href^="http"]').tooltip(search_options);
  $('li.attribute a.btn').tooltip(more_information);
  $('li.attribute a[href^="http"]').tooltip(more_information);
});
