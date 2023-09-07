// JAVASCRIPT: Create a javascript to filter out degree based on selection
$(document).ready(function() {
  // FUNCTION: Setup an on change event to get the selected value of the degree level
  $('#degree_level_select').change(function() {
    // VARIABLE: Setup a string variable to store the value of degree
    var degree_select = '';
    var degree_level = $("#degree_level_select option:selected").val();

    // CONDITION: Check and set condition of degree
    if (degree_level == "Bachelor's") {
      degree_select = 'Bachelor';
    } else if (degree_level == "Master's") {
      degree_select = 'Master';
    } else if (degree_level == "Doctoral") {
      degree_select = 'Doctor';
    } else {
      degree_select = degree_level;
    }

    // FUNCTION: Filter out the degree name based on selection
    $('#degree_name_sort > option').each(function() {
      // CONDITION: Check if the selection has specific keyword to filter out
      if (degree_select == 'Other') {
        $(this).show();
      } else {
        if (this.value.includes(degree_select) || this.value.includes('Other')) {
          $(this).show();
        } else {
          $(this).hide();
        }
      }
    });
  });
});