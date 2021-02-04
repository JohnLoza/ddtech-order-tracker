$(document).on('turbolinks:load', function() {
  // Calculate arrival based on origin estimation
  $("[data-calculate-arrival-onchange]").on("change", function(event) {
    const selectedOpt = $(this).find(":selected")[0];
    console.log('opt selected ', selectedOpt);
    const estimatedDays = $(selectedOpt).attr('data-estimated-shipment-days');
    console.log('estimated days', estimatedDays);

    const estimatedDate = estimateArrival(estimatedDays);
    console.log('estimated date', estimatedDate);

    const target = $(this).attr('data-target');
    const targetEl = document.getElementById(target);
    console.log('target: ', targetEl);
    targetEl.value = estimatedDate;
  });
  // Calculate arrival based on origin estimation

  // Append shipment product fields to form
  $("[data-append-shipment-product]").on("click", function(event) {
    const uuid = Math.random().toString(36).split('.')[1];
    const target = this.dataset.target;
    const container = document.getElementById(target);

    const template = `
      <section class="shipment-product ${uuid} mt-4 mb-4">
        <h4 class="font-weight-bold">Especificación de producto</h4>
        <div class="d-flex form-group">
          <label for="shipment_product_${uuid}_ddtech_id" class="d-none">uuid</label>
          <input type="text" name="shipment_product[${uuid}[ddtech_id]]"
            id="shipment_product_${uuid}_ddtech_id" class="w-100" maxlength=12 required
            placeholder="Clave interna DDTECH">

          <span class="btn btn-danger float-right m-2"
            onclick="removeFromDom('.${uuid}')">
            <i class="fas fa-times"></i>
          </span>
        </div>

        <div class="mt-4 mb-4 p-3 rounded">
          <h3 class="m-0 d-inline-block text-primary font-weight-bold">
            <i class="fas fa-building"></i>
            Destinos
          </h3>
          <h3 class="m-0 d-inline-block text-primary font-weight-bold append-destination-link"
            onclick="appendDestination('${uuid}', 'destinations-container-${uuid}')">
            <i class="fas fa-plus ml-3 pointer"></i>
          </h3>
        </div>
        <section id="destinations-container-${uuid}"></section>
        <hr class="bg-secondary">
      </section>
    `;

    $(container).append(template);
  });
  // Append shipment product fields to form

  const appendShipmentProduct = $("[data-append-shipment-product]")
  if (appendShipmentProduct)
    appendShipmentProduct[0].click();

  const appendDestinationLink = $(".append-destination-link");
  if (appendDestinationLink)
    appendDestinationLink.click();
});

function estimateArrival(days) {
  let estimatedDate = new Date();

  if(isNaN(days)) {
      console.log("Value provided for \"days\" was not a number");
      return
  }
  if(!(estimatedDate instanceof Date)) {
      console.log("Value provided for \"estimatedDate\" was not a Date object");
      return
  }
  // Get the day of the week as a number (0 = Sunday, 1 = Monday, .... 6 = Saturday)
  let dow = estimatedDate.getDay();
  let daysToAdd = parseInt(days);
  // If the current day is Sunday add one day
  if (dow == 0)
      daysToAdd++;
  // If the start date plus the additional days falls on or after the closest Saturday calculate weekends
  if (dow + daysToAdd >= 6) {
      //Subtract days in current working week from work days
      var remainingWorkDays = daysToAdd - (5 - dow);
      //Add current working week's weekend
      daysToAdd += 2;
      if (remainingWorkDays > 5) {
          //Add two days for each working week by calculating how many weeks are included
          daysToAdd += 2 * Math.floor(remainingWorkDays / 5);
          //Exclude final weekend if remainingWorkDays resolves to an exact number of weeks
          if (remainingWorkDays % 5 == 0)
              daysToAdd -= 2;
      }
  }
  estimatedDate.setDate(estimatedDate.getDate() + daysToAdd); // add the necesary days
  estimatedDate = estimatedDate.toISOString().split('T')[0]; // parse to database format
  return estimatedDate;
}

// Append shipment product destination fields to form
window.appendDestination = function(uuid, target) {
  const destination_uuid = Math.random().toString(36).split('.')[1];
  const container = document.getElementById(target);
  const template = `
    <section class="shipment-destination ${destination_uuid}">
      <div class="d-flex form-group">
        <label for="shipment_product_${uuid}_destinations_${destination_uuid}_destination" class="d-none"></label>

        <input type="text" name="shipment_product[${uuid}[destinations[${destination_uuid}[destination]]]]"
          id="shipment_product_${uuid}_destinations_${destination_uuid}_destination"
          class="w-100" maxlength=50 required placeholder="Destino">

        <span class="btn btn-danger float-right m-2"
          onclick="removeFromDom('.${destination_uuid}')">
          <i class="fas fa-times"></i>
        </span>
      </div>

      <div class="d-flex form-group">
        <label for="shipment_product_${uuid}_destinations_${destination_uuid}_units" class="d-none">units</label>

        <input type="number" name="shipment_product[${uuid}[destinations[${destination_uuid}[units]]]]"
          id="shipment_product_${uuid}_destinations_${destination_uuid}_units"
          class="w-100" step=1 min=1 required placeholder="Unidades">
      </div>
    </section>
  `;
  $(container).append(template);
};
// Append shipment product destination fields to form
