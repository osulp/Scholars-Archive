import { TriplePoweredPropertyButton } from './button'

export class TriplePoweredPropertyControl {
  constructor(element) {
    // Don't try to make sense of this URL regex, it will fry your brain. See: http://stackoverflow.com/a/9284473
    this.urlPattern = new RegExp(/^(?:(?:https?|ftp):\/\/)(?:\S+(?::\S*)?@)?(?:(?!(?:10|127)(?:\.\d{1,3}){3})(?!(?:169\.254|192\.168)(?:\.\d{1,3}){2})(?!172\.(?:1[6-9]|2\d|3[0-1])(?:\.\d{1,3}){2})(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|(?:(?:[a-z\u00a1-\uffff0-9]-*)*[a-z\u00a1-\uffff0-9]+)(?:\.(?:[a-z\u00a1-\uffff0-9]-*)*[a-z\u00a1-\uffff0-9]+)*(?:\.(?:[a-z\u00a1-\uffff]{2,}))\.?)(?::\d{2,5})?(?:[/?#]\S*)?$/,'i');
    this.$element = $(element);

    // Any of the triple powered property label lists that were rendered need to have their toggle button
    // wired up to provide the collapsable effect
    this.$element.find("span.toggle").each((i, el) => {
      new TriplePoweredPropertyButton(el);
    });

    this.bindBlurHandler();
    this.bindKeyupHandler();
    this.bindManagedFieldAddHandler();
  }

  // delegate blur events to the form-control that fired them, works with new fields that are added dynamically by way
  // of the "+ more" button managed by hydra-editor
  bindBlurHandler() {
    this.$element.on("blur", "input.form-control", (e) => {
      var $input = $(e.currentTarget);

      // disallow space characters in triple powered property fields, these will not be valid URIs
      $input.val($input.val().replace(' ', ''));

      // hide a previously displayed warning to revalidate the field for URLness
      var $warning = $(e.currentTarget).siblings('.has-warning');
      $warning.text("").addClass("hidden");

      // input value has text and doesn't pass the URL regex test
      if($input.val() !== '' && !this.urlPattern.test($(e.currentTarget).val())){
        $warning.text("Invalid URL").removeClass("hidden");
      }
    });
  }

  // Remove the warning message when a user types into the "new" field managed by hydra-editor. This hides the warning
  // message "you cannot add a blank field" if it was displayed to the user previously.
  bindKeyupHandler() {
    this.$element.on("keyup", "input.form-control", (e) => {
      var $input = $(e.currentTarget);
      var $li = $input.parents("li");

      // This warning message is injected by hydra-editor for mult_value fields wrapped in a UL list
      if($li){
        if($li.find(".field-controls .btn.add").length > 0 && $input.val().length > 0) {
          $li.siblings(".has-warning").remove();
        }
      }
    });
  }

  // After the add button is clicked, hydra-editor clones the LI and clears its fields before injecting the new LI
  // to the end of the list.. Make sure this new LI has the URL validation warning field hidden since it is expecting
  // the user to enter a new one
  bindManagedFieldAddHandler(){
    this.$element.on("click", ".btn.add", (e) => {
      $(e.delegateTarget).find("ul li:last .has-warning").addClass("hidden");
    });
  }
}
