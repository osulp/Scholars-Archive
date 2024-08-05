// JAVASCRIPT: Write a script to detect if file upload or URL are being enter
$(document).ready(function() {
  // FETCH: Get value before field 
  var extFieldCurr = $('#ext_relation_curr').detach();
  var fileFieldCurr = $('#file_curr').detach();

  // FUNCTION: Check status of both field to see if the upload file area isn't double use
  $('#with_files_submit').on( "click", function() {
    // GET: Select the value from the work
    var fileField = $('input[name="uploaded_files[]"]');
    var extFieldNew = $('input[name="ext_relation[]"]:valid');
    
    // CHECK: Check to see if the file length or text value is both fill out
    if (fileField.length > 0 && extFieldNew.val().length > 0) {
      alert('ERROR! Please only submit one of the following, either only a file upload or an URL link');
      return false;
    } else if ((extFieldCurr.text().length != 0) && (extFieldNew.val().length == 0)) {
      alert('ERROR! Please do not leave URL blank. Either delete the FileSet or input in a new value into the field');
      return false;
    } else if ((parseInt(fileFieldCurr.text()) != 0) && (extFieldNew.val().length > 0)) {
      alert('ERROR! It seems like you have one more more file uploads in the work already. Please delete it first before');
      return false;
    }
  });
});
