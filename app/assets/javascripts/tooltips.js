//= require bootstrap

$(document).on('ready turbolinks:load', function() {
  var search_options = {
    placement: 'top',
    title: 'Search for this term in SA@OSU'
  };

  $('.metadata > .table a').not('.btn').tooltip(search_options);
  $('li.attribute a').not('.btn').tooltip(search_options);
  $('li.attribute a.btn').tooltip({
    placement: 'top',
    title: 'More information about this item'
  });
});
