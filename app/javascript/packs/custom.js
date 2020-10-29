import './bootstrap_custom.js'

import '@fortawesome/fontawesome-free/js/fontawesome.min.js'
import '@fortawesome/fontawesome-free/js/solid.min.js'

import 'jquery-slimscroll/jquery.slimscroll.min.js'
import 'bootstrap-datepicker/dist/js/bootstrap-datepicker.min.js'

import { Chart } from 'chart.js/dist/Chart.min.js'
import './charts'

import 'parsleyjs/dist/parsley.min.js'
import 'parsleyjs/dist/i18n/es.js'

import './concept'

import './notes'
import './update_order_guide'
import './update_order_status'

import './on_turbolinks_load'

window.toggleChevron = function(trigger) {
  $(trigger).find('svg').toggleClass('fa-chevron-up fa-chevron-down');
};

window.removeFromDom = function(target) {
  $(target).remove();
}
