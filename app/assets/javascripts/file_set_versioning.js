// #1812 Update file name on version update
$(document).ready(function() {
  $('#file_set_files').on('input', function(event) {
    // Replace FileSet title with name of new file
    $('#file_set_title_').val(event.target.files[0].name);

    // Warn the user after the first change and let the warning stay on every change after
    let warningElem = '<div id="title-warning" class="alert alert-warning" role="alert"><strong>Warning:</strong> The title of this fileset has changed to match the above file name.<br/><a href="#descriptions_display">Check the description tab to verify your title</a></div>';
    if ($('#title-warning').length == 0) {
      $(event.currentTarget).parents('form').after(warningElem);
    }
  });
});