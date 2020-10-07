$(document).on('turbolinks:load', function () {
  $('form').parsley(); // initialize parsley

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
  // prevent spaces

  // initialize datepicker
  $('.datepicker').datepicker({
    autoclose: true,
    format: 'yyyy-mm-dd',
    orientation: 'bottom',
  });
  // initialize datepicker

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
