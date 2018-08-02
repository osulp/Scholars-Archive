$(document).on('ready turbolinks:load', function() {
  var search_options = {
    placement: 'top',
    title: 'Search for this term in SA@OSU'
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
