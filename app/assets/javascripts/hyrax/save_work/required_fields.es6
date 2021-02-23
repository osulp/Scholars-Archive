export class RequiredFields {
  // Monitors the form and runs the callback if any of the required fields change
  constructor(form, callback) {
    this.form = form
    this.callback = callback
    this.reload()
  }

  get areComplete() {
    this.embargoSelected = this.visibilityFields.filter(':checked').val() === 'embargo'
    this.embargoDateOther = this.form.find('#embargo_date_select option:selected:visible').val() === 'other'

    return this.embargoValid() && this.requiredFieldsValid()
  }

  embargoValid() {
    return !this.embargoSelected || !this.embargoDateOther || !this.isValuePresent(this.embargoDateFields[0])
  }

  requiredFieldsValid() {
    return this.requiredFields.filter((n, elem) => { return this.isValuePresent(elem) } ).length === 0
  }

  isValuePresent(elem) {
    return ($(elem).val() === null) || ($(elem).val().length < 1)
  }

  // Reassign requiredFields because fields may have been added or removed.
  reload() {
    // ":input" matches all input, select or textarea fields.
    this.requiredFields = this.form.find(':input[required]')
    this.requiredFields.change(this.callback)
    this.visibilityFields = this.form.find('[name$="[visibility]"]')
    this.visibilityFields.change(this.callback)
    this.embargoSelectFields = this.form.find('#embargo_date_select')
    this.embargoSelectFields.change(this.callback)
    this.embargoDateFields = this.form.find('[id$=embargo_release_date]')
    this.embargoDateFields.change(this.callback)
  }
}
