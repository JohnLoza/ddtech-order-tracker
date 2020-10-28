$(document).on('turbolinks:load', function () {
  $('form').parsley(); // initialize parsley

  // submit form on enter
  $("[data-submit-on-enter]").on("keydown", function(event) {
    if (event.keyCode === 13) {
      if (event.shiftKey)
        return;
      event.preventDefault();
      const form = $(this).parents('form')[0];
      $(form).children('[type=submit]').click();
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
  $("[data-prevent-spaces]").on("paste", function(event) {
    event.preventDefault();
    let pasted_text = event.originalEvent.clipboardData.getData('text')
    $(this).val(pasted_text.replace(/[\s]+/g, ''));
  });
  // prevent spaces

  // initialize datepicker
  $('.datepicker').datepicker({
    autoclose: true,
    format: 'yyyy-mm-dd',
    orientation: 'bottom',
  });
  // initialize datepicker

  // select a style for the new/editing tag
  $("[data-tag-style]").on("click", function(event) {
    $(".tag.active").removeClass("active"); // remove old active style
    $("#tag_css_class").val($(this).attr("class")); // add new value to css_class field
    $(this).addClass("active"); // set this style as active
  });
  // select a style for the new/editing tag

  // remove dom element on click
  $("[data-remove-dom-el-on-click]").on("click", function(event) {
    let target = $(this).attr('data-remove-dom-el-on-click');
    $(`#${target}`).remove();
  });
  // remove dom element on click

  // initialize charts
  if(document.getElementById('orders-by-parcel'))
    initChart('orders-by-parcel', 'Pedidos por Paquetería');

  if(document.getElementById('pendant-orders'))
    initChart('pendant-orders', 'Pedidos en Cola');

  if(document.getElementById('orders-by-user'))
    initChart('orders-by-user', 'Pedidos por Usuario');

  if(document.getElementById('supplied-orders'))
    initChart('supplied-orders', 'Pedidos Surtidos');

  if(document.getElementById('assembled-orders'))
    initChart('assembled-orders', 'Pedidos Ensamblados');

  if(document.getElementById('packed-orders'))
    initChart('packed-orders', 'Pedidos Empaquetados');

  if(document.getElementById('guides-registered'))
    initChart('guides-registered', 'Guías Registradas');
  // initialize charts
});
