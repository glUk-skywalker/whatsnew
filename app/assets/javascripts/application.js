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

function createCookie(name,value,days) {
  if (days) {
    var date = new Date();
    date.setTime(date.getTime()+(days*24*60*60*1000));
    var expires = "; expires="+date.toGMTString();
  }
  else var expires = "";
  document.cookie = name+"="+value+expires+"; path=/";
}

function readCookie(name) {
    var nameEQ = name + "=";
    var ca = document.cookie.split(';');
    for(var i=0;i < ca.length;i++) {
        var c = ca[i];
        while (c.charAt(0)==' ') c = c.substring(1,c.length);
        if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
    }
    return null;
}

//===================================================================================

$("document").ready(function() {
    $(".build-link").click(function(){
      $(".build-link").removeClass("selected");
      $(".build-row").removeClass("selected");
      $(this).addClass("selected");
      $(this).parent().parent().addClass("selected");
    });

    setTimeout(function() {
        $("#build-link").trigger('click');
    },10);
});

$(document).on("change", "#check-all", function(){ $("[data-toggle=popover]").popover(); });


$(function() {
  $('#loading-indicator').hide();  // hide it initially.
  $('#build-info').show();
  $(document)  
    .ajaxStart(function() {
      $('#loading-indicator').show(); // show on any Ajax event.
      $('#build-info').hide();
      $('#stats-subcontainer').hide();
    })
    .ajaxStop(function() {
      $('#loading-indicator').hide(); // hide it when it is done.
      $('#build-info').show();
      $('#stats-subcontainer').show();

      //reactivate js functions after ajax:
      $(".stats-checkbox").click(function() {
        $(".collapse").removeClass("out");
        $(".collapse").addClass("in");
        createCookie("show_" + this.id, this.checked, 30)

        $(".stats-checkbox").each(function(){
          if( !$(this).is(":checked") ) {
            $(".collapse." + $(this).attr("id")).removeClass("in");
            $(".collapse." + $(this).attr("id")).addClass("out");
          }
        });
      });

      $(".stats-checkbox").each(function() {
        if(readCookie("show_" + this.id) == 'false'){
          this.click();
        };
      });
    });
});
