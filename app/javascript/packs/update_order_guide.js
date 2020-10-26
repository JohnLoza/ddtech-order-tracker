$(document).on('turbolinks:load', function () {
  // handle update_order_guide form response
  $("#update_order_guide").on("ajax:success", function(event){
    const ddtech_key = $("#order_ddtech_key").val();
    $(".processed-orders").prepend(`
      <p>
        <i class='fas fa-fw fa-check fa-lg text-success'></i>
        <i class='fas fa-fw fa-chevron-right'></i>
        Se capturó la(s) guía(s) para el pedido <strong>#${ddtech_key}</strong>
      </p>
    `);
    $("#order_ddtech_key").val("");
    $("#order_guide").val("");
    $("#order_data").val("");
    $(".guides-container").html("");
    $("#order_ddtech_key").focus();
  }).on("ajax:error", function(event) {
    console.log('error event: ', event.detail);
    const ddtech_key = $("#order_ddtech_key").val();
    $(".processed-orders").prepend(`
      <p>
        <i class='fas fa-fw fa-time fa-lg text-danger'></i>
        <i class='fas fa-fw fa-chevron-right'></i>
        Ocurrió un error al capturar la(s) guía(s) para el pedido <strong>#${ddtech_key}</strong>
      </p>
    `);
  });
  // handle update_order_guide form response
});

window.appendGuideField = function() {
  const hash_id = Math.random().toString(36).substr(2);
  $(".guides-container").append(`
    <div class="form-group row ${hash_id}">
      <div class="col-md-10 col-8">
        <input name="order[guide][]" class="form-control" type="text"
          data-prevent-enter="true">
      </div>
      <div class="col-md-2 col-4">
        <i class="fas fa-times fa-2x text-danger pointer"
          onclick="removeFromDom('.${hash_id}')"></i>
      </div>
    </div>
  `);

  $("[data-prevent-enter]").on("keydown", function(event) {
    if (event.keyCode === 13)
      event.preventDefault();
  });
  $(`.${hash_id}`).find('input').focus();
};
