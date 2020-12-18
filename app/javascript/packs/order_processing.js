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
    updateOrderProcessingResult(event, ddtech_key);
    $("#order_ddtech_key").val("");
    $("#order_data").val("");
  }).on("ajax:error", function(event) {
    const ddtech_key = $("#order_ddtech_key").val();
    updateOrderProcessingResult(event, ddtech_key);
  });
  // handle update_order_status form response

  // handle update_order_guide form response
  $("#update_order_guide").on("ajax:success", function(event){
    const ddtech_key = $("#order_ddtech_key").val();
    updateOrderProcessingResult(event, ddtech_key);

    $("#order_ddtech_key").val("");
    $("#order_guide").val("");
    $("#order_data").val("");
    $("#order_per_package_parcel").val("");

    $(".guides-container").html("");
    $("#order_ddtech_key").focus();
  }).on("ajax:error", function(event) {
    const ddtech_key = $("#order_ddtech_key").val();
    updateOrderProcessingResult(event, ddtech_key);
  });
  // handle update_order_guide form response
});

// update ui with the result
function updateOrderProcessingResult(event, ddtech_key) {
  const status = event.detail[2].status;
  const icon = status == 200 ? 'fa-check text-success' : 'fa-times text-danger';
  const msg = status == 200 ? 'Se procesó el pedido' :
    status == 404 ? 'El pedido no existe' : 'Ocurrió un error al procesar el pedido';

  $(".processed-order").html(`
    <p>
      <i class='fas fa-fw ${icon} fa-lg'></i>
      <i class='fas fa-fw fa-chevron-right'></i>
      ${msg}
      <strong>#${ddtech_key}</strong>
      <div class="result-errors-container"></div>
      <div class="result-tags-container"></div>
      <div class="result-notes-container"></div>
    </p>
  `);

  const errors = event.detail[0].errors;
  if (errors && errors.length > 0) {
    const el = $(".result-errors-container");
    el.append(`<p><strong>Estado actual del pedido:</strong> <span class="badge badge-pill badge-primary">${event.detail[0].data.status_was}</span></p>`);
    el.append("<p class='font-weight-bold'>Errores:</p>");
    errors.forEach(error => el.append(`<p>* ${error}</p>`));
    el.append("<hr>");
  }

  if (status == 404) return; // return now if its a not found response

  if ((tags = event.detail[0].data.tags).length > 0) {
    const el = $(".result-tags-container");
    el.append("<p class='font-weight-bold'>Etiquetas:</p>");
    tags.forEach(tag => el.append(`<span class="${tag.css_class}">${tag.name}</span>`));
    el.append("<hr>");
  }

  if ((notes = event.detail[0].data.notes).length > 0) {
    const el = $(".result-notes-container");
    el.append("<p class='font-weight-bold'>Notas:</p>");
    notes.forEach(note => el.append(`<p>* ${note.message}</p>`));
    el.append("<hr>");
  }
}
// update ui with the result

// append another guide field
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
// append another guide field
