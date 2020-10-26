$(document).on('turbolinks:load', function () {
  // show or hide the users selectors depending on process selected
  $("#order_status").on("change", function() {
    const els = $(".users-select");
    els.addClass("d-none");
    els.attr("disabled", "disabled");

    let select;
    switch (this.value) {
      case "warehouse_entry":
        select = document.getElementsByClassName("warehouse-users")[0]
        break;
      case "assemble_entry":
        select = document.getElementsByClassName("assembler-users")[0]
        break;
      case "packed":
        select = document.getElementsByClassName("packer-users")[0]
        break;
    }

    if (select) {
      select.classList.remove("d-none");
      select.removeAttribute("disabled");
    }
  });
  // show or hide the users selectors depending on process selected

  // handle update_order_status form response
  $("#update_order_status").on("ajax:success", function(event){
    const ddtech_key = $("#order_ddtech_key").val();
    $(".processed-orders").prepend(`
      <p>
        <i class='fas fa-fw fa-check fa-lg text-success'></i>
        <i class='fas fa-fw fa-chevron-right'></i>
        Se procesó el pedido
        <strong>#${ddtech_key}</strong>
      </p>
    `);
    $("#order_ddtech_key").val("");
    $("#order_data").val("");
  }).on("ajax:error", function(event) {
    console.log('error event: ', event.detail);
    const ddtech_key = $("#order_ddtech_key").val();
    $(".processed-orders").prepend(`
      <p>
        <i class='fas fa-fw fa-time fa-lg text-danger'></i>
        <i class='fas fa-fw fa-chevron-right'></i>
        Ocurrió un error al procesar el pedido
        <strong>#${ddtech_key}</strong>
      </p>
    `);
  });
  // handle update_order_status form response
});
