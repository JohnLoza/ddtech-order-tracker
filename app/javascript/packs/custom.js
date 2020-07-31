import './bootstrap_custom.js'
import '@fortawesome/fontawesome-free/js/all.min.js'
import 'jquery-slimscroll'
import 'parsleyjs'
import 'parsleyjs/dist/i18n/es'
import './concept.js'

$(document).on('turbolinks:load', function () {
  $('form').parsley();

  // handle new_note form response
  $("#new_note").on("ajax:success", function(event){
    const response = event.detail[0];
    $(".notes-container").prepend(response.template);
    $("#note_message").val("");
  }).on("ajax:error", function(event) {
    console.log('error event: ', event.detail);
  });

  // handle update_order_status form response
  $("#update_order_status").on("ajax:success", function(event){
    const ddtech_key = $("#order_ddtech_key").val();
    $(".processed-orders").prepend(`
      <p>Se procesó el pedido
        <strong>#${ddtech_key}</strong>
      </p>
    `);
    $("#order_ddtech_key").val("");
  }).on("ajax:error", function(event) {
    console.log('error event: ', event.detail);
    const ddtech_key = $("#order_ddtech_key").val();
    $(".processed-orders").prepend(`
      <p>Ocurrió un error al procesar el pedido
      <strong>#${ddtech_key}</strong>
      </p>
    `);
  });

  $("[data-submit-on-enter]").on("keydown", function(event) {
    if (event.keyCode === 13) {
      if (event.shiftKey)
        return;
      event.preventDefault();
      const target = this.dataset.target;
      $(target).click();
    }
  });
});

window.toggleChevron = function(trigger) {
  $(trigger).find('svg').toggleClass('fa-chevron-up fa-chevron-down');
};
