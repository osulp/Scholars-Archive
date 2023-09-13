// JAVASCRIPT: Create a javascript to filter out degree on work
$(document).ready(function() {
  // GET: Select the value of the work
  var work_selection = $('#degree_work_select').val();

  // LOOP: Filter out the degree level based on work
  $('#degree_level_select > option').each(function() {
    // CONDITION: Check if the selection has specific keyword to filter out
    if (work_selection.includes("Undergraduate") || work_selection.includes("Honors")) {
      if(this.value.includes("Bachelor's") || this.value.includes("Other")) {
        $(this).show();
      } else {
        $(this).hide();
      }
    } else if (work_selection.includes("Graduate project")) {
      if(this.value.includes("Bachelor's")) {
        $(this).hide();
      } else {
        $(this).show();
      }
    } else if (work_selection.includes("Graduate thesis")) {
      if(this.value.includes("Bachelor's") || this.value.includes("Certificate")) {
        $(this).hide();
      } else {
        $(this).show();
      }
    } else {
      $(this).show();
    }
  });
});