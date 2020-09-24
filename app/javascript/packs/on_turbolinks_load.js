$(document).on('turbolinks:load', function () {
  $('form').parsley();

  // submit form on enter
  $("[data-submit-on-enter]").on("keydown", function(event) {
    if (event.keyCode === 13) {
      if (event.shiftKey)
        return;
      event.preventDefault();
      const target = this.dataset.target;
      $(target).click();
    }
  });
  // submit form on enter

  // submit form on enter
  $("[data-prevent-enter]").on("keydown", function(event) {
    if (event.keyCode === 13)
      event.preventDefault();
  });
  // submit form on enter

  // prevent spaces
  $("[data-prevent-spaces]").on("keydown", function(event) {
    if (event.keyCode === 32)
      event.preventDefault();
  });
});
