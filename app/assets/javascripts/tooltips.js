Blacklight.onLoad(function() {
  var search_options = {
    placement: 'top',
    title: 'Search for this term in SA@OSU'
  };
  var mailto_options = {
    placement: 'top',
    title: 'Compose an email'
  };
  var more_information = {
    placement: 'top',
    title: 'More information about this item'
  };
  var external_information = {
    placement: 'top',
    title: 'Visit External Link'
  };

  $('li.attribute a[href^="mailto"]').tooltip(mailto_options);
  $('.metadata > .table a').not('.btn').tooltip(search_options);
  $('li.attribute a').not('.btn').not('[href^="http"]').tooltip(search_options);
  $('li.attribute a.btn').tooltip(more_information);
  $('li.attribute a[href^="http"]').tooltip(external_information);
});
