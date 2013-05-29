//= require jquery
//= require jquery_ujs
//= require bootstrap-datepicker/bootstrap-datepicker

//= require bootstrap
//= require chosen.jquery

//= require_tree .
//= require_self
//= require ckeditor/init
//= require_tree ../ckeditor

$(function() {
  $('.date-input').datepicker({
    language: 'zh-CN',
    format: 'yyyy-mm-dd',
    autoclose: true
  });

  $('.auto-date-input').datepicker({
    language: 'zh-CN',
    format: 'yyyy-mm-dd',
    autoclose: true
  }).on('changeDate', function(ev) {
      $(this).parent('form').submit();
  });
});
