// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

import '../stylesheets/sessions.scss'

import './bootstrap_custom.js'

import '@fortawesome/fontawesome-free/js/fontawesome.min.js'
import '@fortawesome/fontawesome-free/js/solid.min.js'

import 'parsleyjs/dist/parsley.min.js'
import 'parsleyjs/dist/i18n/es.js'

$(document).ready(function() {
  $('form').parsley(); // initialize parsley

  $("[data-disable]").on("change", function(event) {
    const target = $(this).attr("data-disable");
    $(target).val("");
    $(target).attr("disabled", true);
  });

  $("[data-enable]").on("change", function(event) {
    const target = $(this).attr("data-enable");
    $(target).removeAttr("disabled");
    $(target).focus();
  });

  function clearFiscalRegimenRadios() {
    for(let option of $('label.fiscal-regimen')) {
      option.children[0].checked = false;
    }
  }

  $("#ml_billing_person_type").on("change", function(event) {
    const target = $(this);
    if (target.val() == 'Moral') {
      clearFiscalRegimenRadios();
      for(let option of $('label.fiscal-regimen.physical')) {
        option.classList.add('d-none');
      }
      for(let option of $('label.fiscal-regimen.moral')) {
        option.classList.remove('d-none');
      }
    } else if (target.val() == 'Física') {
      clearFiscalRegimenRadios();
      for(let option of $('label.fiscal-regimen.physical')) {
        option.classList.remove('d-none');
      }
      for(let option of $('label.fiscal-regimen.moral')) {
        option.classList.add('d-none');
      }
    }
  });
});

