// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap
//= require_tree .

$("document").ready(function() {
    setTimeout(function() {
        $("#build-link").trigger('click');
    },10);
});



$(function() {
  $('#loading-indicator').hide();  // hide it initially.
  $('#build-info').show();
  $(document)  
    .ajaxStart(function() {
      $('#loading-indicator').show(); // show on any Ajax event.
      $('#build-info').hide();
    })
    .ajaxStop(function() {
      $('#loading-indicator').hide(); // hide it when it is done.
      $('#build-info').show();
  });
});
