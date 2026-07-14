// SCRIPT: Validate the Latitude & Longitude
$(document).on('input', '.bbox_nested_lat', function() {
  validateLatLon($(this), 'lat');
});

$(document).on('input', '.bbox_nested_lon', function() {
  validateLatLon($(this), 'lon');
});

// METHOD: The core of validating the two, lat & lon
function validateLatLon($input, type) {
  // GET: Get value directly from the input, and trimmed for space
  const value = $input.val().trim();

  // FIND: Get the correct error display
  const $error = type === 'lat' ? $input.closest('.latitude-wrapper').find('.lat-error') : $input.closest('.longitude-wrapper').find('.lon-error');

  // IF: If empty or just '-', hide error and remove invalid
  if (value === '' || value === '-') {
    $error.hide();
    $input.removeClass('invalid');
    checkErrorOnSubmission($input);
    return;
  }

  // REGEX: Check to see if it is a valid number
  const numberRegex = /^-?\d+(\.\d+)?$/;
  const num = parseFloat(value);

  // CHECK: Validate range
  let valid = true;
  if (type === 'lat' && (isNaN(num) || num < -90 || num > 90 || !numberRegex.test(value))) valid = false;
  if (type === 'lon' && (isNaN(num) || num < -180 || num > 180 || !numberRegex.test(value))) valid = false;

  // SHOW: Show or hide error
  if (!valid) {
    $error.show();
    $input.addClass('invalid');
  } else {
    $error.hide();
    $input.removeClass('invalid');
  }

  // CHECK: Update submit button
  checkErrorOnSubmission($input);
}

// METHOD: Submit button state logic
function checkErrorOnSubmission($input) {
  // GET: Fetch the form value
  const $form = $input.closest('form');
  const $lat = $form.find('.bbox_nested_lat');
  const $lon = $form.find('.bbox_nested_lon');
  const latVal = $lat.val().trim();
  const lonVal = $lon.val().trim();

  // GET: Fetch the bool isValid state
  const latInvalid = $lat.hasClass('invalid');
  const lonInvalid = $lon.hasClass('invalid');

  // DETERMINE: Check to see if any of this are presented
  let disable = latInvalid || lonInvalid || (!!latVal !== !!lonVal);

  $('#with_files_submit').prop('disabled', disable);
}
