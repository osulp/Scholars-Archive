// JAVASCRIPT: Write a script to detect if file upload or URL are being enter
$(document).ready(function() {
  // FUNCTION: Check status of both field to see if the upload file area isn't double use
  $('#with_files_submit').on( "click", function() {
    // GET: Select the value from the work
    var fileField = $('input[name="uploaded_files[]"]');
    var extField = $('input[name="ext_relation[]"]:valid');
    
    // CHECK: Check to see if the file length or text value is both fill out
    if (fileField.length > 0 && extField.val().length > 0) {
      alert('ERROR! Please only submit one of the following, either only a file or an URL link');
      return false;
    }
  });
});
