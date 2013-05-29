//= require jquery
//= require jquery_ujs
//= require bootstrap-datepicker/bootstrap-datepicker

//= require gmaps4rails/gmaps4rails.base
//= require gmaps4rails/gmaps4rails.googlemaps
//
//= require bootstrap

//= require ./admin/areas
//= require ./cart

$(function() {
  $('.date-input').datepicker({ 
    language: 'zh-CN',
    format: 'yyyy-mm-dd',
    autoclose: true,
    startDate: new Date()
  });

  $('.date-input-full').datepicker({ 
    language: 'zh-CN',
    format: 'yyyy-mm-dd',
    autoclose: true
  });

  $('#venue-grid-date-input').datepicker({
    language: 'zh-CN',
    format: 'yyyy-mm-dd',
    autoclose: true,
    startDate: new Date()
  }).on('changeDate', function(ev) {
    $(this).parent('form').submit();
  });

  $('.venue-grid .item a').popover({
    'trigger': 'hover',
    'placement': 'top'
  });

  $('[rel="tooltip"]').tooltip();
});
