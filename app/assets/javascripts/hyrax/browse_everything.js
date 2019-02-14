/*
OVERRIDE: This files overrides browse_everything.js so that browseEverything 
can be loaded properly. It seems to be a known issue in hyrax. See issue 169:
https://github.com/samvera/browse-everything/issues/169

Base file:
https://github.com/samvera/hyrax/blob/v2.3.0/app/assets/javascripts/hyrax/browse_everything.js

*/

//= require jquery.treetable
//= require browse_everything/behavior

$(document).on('ready turbolinks:load', function() {
  if ($('#browse-btn').length > 0) {
    $('#browse-btn').browseEverything()
      .done(function(data) {
        var evt = { isDefaultPrevented: function() { return false; } };
        var files = $.map(data, function(d) { return { name: d.file_name, size: d.file_size, id: d.url } });
        $.blueimp.fileupload.prototype.options.done.call($('#fileupload').fileupload(), evt, { result: { files: files }});
      })
  }
  $('#browse-btn').browseEverything()
    .done(function(data) { $('#status').html(data.length.toString() + " items selected") })
    .cancel(function() { window.alert('Canceled!') });
});
