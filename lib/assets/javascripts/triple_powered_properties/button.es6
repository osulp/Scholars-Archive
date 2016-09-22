export class TriplePoweredPropertyButton {
  constructor(element) {
    this.$element = $(element);
    this.$list = this.$element.siblings(".list:first");

    this.$element.on('click', (e) => {
      this.$list.toggle((e) => {
        if(this.$list.is(":visible")){
          this.$element.text(this.$element.data('hide-all'));
        } else {
          this.$element.text(this.$element.data('show-all'));
        }
      })
    });
  }
}