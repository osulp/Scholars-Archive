// MODIFY: Override to modify a way to detect only one field can be use in the files area
export class UploadedFiles {
  // Monitors the form and runs the callback when files are added
  constructor(form, callback) {
    this.form = form
    this.element = $('#fileupload')
    this.element.bind('fileuploadcompleted', callback)
    this.element.bind('fileuploaddestroyed', callback)
    $('#ext_relation').bind('blur', callback)
  }

  get hasFileRequirement() {
    let fileRequirement = this.form.find('li#required-files')
    return fileRequirement.length > 0
  }

  get inProgress() {
    return this.element.fileupload('active') > 0
  }

  // CHECK: Here we check if there is either one of the field fill out
  get hasFiles() {
    let fileField = this.form.find('input[name="uploaded_files[]"]')
    let extField = this.form.find('input[name="ext_relation[]"]:valid')
    
    return (fileField.length > 0 && !extField.val()) || (extField.val() && fileField.length < 1)
  }

  get hasNewFiles() {
    // In a future release hasFiles will include files already on the work plus new files,
    // but hasNewFiles() will include only the files added in this browser window.
    return this.hasFiles
  }
}
