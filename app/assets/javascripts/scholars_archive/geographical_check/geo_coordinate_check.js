// SCRIPT: Run on input to check if Latitude & Longitude enter correctly
$(document).on('input', '.bbox_nested_lat', function() {
  // GET: Get the value of the input from lat
  var $input = $(this);
  var value = $input.val().trim();

  // FIND: Get the div with the error message
  var $error = $input.closest('.latitude-wrapper').find('.lat-error');

  // IF: If field is empty (no input) or have a '-', hide error
  if (value === '-' || value === '') {
    $error.hide();
    $input.removeClass('invalid');
    checkErrorOnSubmmission(value);
    return;
  }

  // REGEX: Check if entire string must be a valid decimal number
  var numberRegex = /^-?\d+(\.\d+)?$/;

  // CONVERT: Convert to number
  var num = parseFloat(value);

  // IF: Show error if not a number or out of range
  if (isNaN(num) || num < -90 || num > 90 || !numberRegex.test(value)) {
    // ADD: Add the text to the div if it is incorrect
    $error.text('Latitude must be a number from -90 to 90').show();
    $input.addClass('invalid');
  } else {
    $error.hide();
    $input.removeClass('invalid');
  }

  checkErrorOnSubmmission(value);
});

$(document).on('input', '.bbox_nested_lon', function() {
  // GET: Get the value of the input from lon
  var $input = $(this);
  var value = $input.val().trim();

  // FIND: Get the div with the error message
  var $error = $input.closest('.longitude-wrapper').find('.lon-error');

  // IF: If field is empty (no input) or have a '-', hide error
  if (value === '-' || value === '') {
    $error.hide();
    $input.removeClass('invalid');
    checkErrorOnSubmmission(value);
    return;
  }

  // REGEX: Check if entire string must be a valid decimal number
  var numberRegex = /^-?\d+(\.\d+)?$/;

  // CONVERT: Convert to number
  var num = parseFloat(value);

  // IF: Show error if not a number or out of range
  if (isNaN(num) || num < -180 || num > 180 || !numberRegex.test(value)) {
    // ADD: Add the text to the div if it is incorrect
    $error.text('Longitude must be a number from -180 to 180').show();
    $input.addClass('invalid');
  } else {
    $error.hide();
    $input.removeClass('invalid');
  }

  checkErrorOnSubmmission(value);
});

// METHOD: Has a method checkign to see if submitting button is clickable
function checkErrorOnSubmmission(value) {
  // CHECK: Check on disable if return true
  var errorCheck = $('.lat-error:visible').length > 0 || $('.lon-error:visible').length > 0 || value === '-';
  $('#with_files_submit').prop('disabled', errorCheck);
}