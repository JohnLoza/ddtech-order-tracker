import './bootstrap_custom.js'
import '@fortawesome/fontawesome-free/js/all.min.js'
import 'jquery-slimscroll'
import 'parsleyjs'
import 'parsleyjs/dist/i18n/es'
import './concept.js'

$(document).on('turbolinks:load', function () {
  console.log('Page loaded', document.title);
  $('form').parsley();
});
