import './bootstrap_custom'
import '@fortawesome/fontawesome-free/js/all.min.js'
import 'jquery-slimscroll'
import 'bootstrap-datepicker'

import { Chart } from 'chart.js'
import './charts'

import 'parsleyjs'
import 'parsleyjs/dist/i18n/es'

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
