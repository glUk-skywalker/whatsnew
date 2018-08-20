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
//= require app_assets
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
      createCookie("selected_build", this.text, 30);
      $(".build-link").removeClass("selected");
      $(".build-row").removeClass("selected");
      $(this).addClass("selected");
      $(this).parent().parent().addClass("selected");
    });

    setTimeout(function() {
      //var selected_build = readCookie("selected_build");
      //alert("build: " + selected_build.length);
      if( readCookie("selected_build") != null ){
        var build_link = $('a:contains(' + readCookie("selected_build") + ')')
        if(build_link.length){
          build_link.click();
          return;
        }
      }

      $("#build-link").trigger('click');
    },10);
});

$(function() {
  $('#loading-indicator').hide();  // hide it initially.
  $('#build-info').show();
  $(document)
    .ajaxStart(function() {
      $(".build-link").css('pointer-events','none');
      $('#loading-indicator').show(); // show on any Ajax event.
      $('#build-info').hide();
      $('#stats-subcontainer').hide();
    })
    .ajaxStop(function() {
      $(".build-link").css('pointer-events','');
      $('#loading-indicator').hide(); // hide it when it is done.
      $('#build-info').show();
      $('#stats-subcontainer').show();

      //reactivate js functions after ajax:

      $(".stats-checkbox").click(function() {
        $(".collapse").removeClass("out");
        $(".collapse").addClass("in");
        createCookie("show_" + this.id, this.checked, 30)

        $(".stats-checkbox").not(".verificator").each(function(){
          if( !$(this).is(":checked") ) {
            $(".collapse." + $(this).attr("id")).removeClass("in").addClass("out");
          }
        });
        if( $(".stats-checkbox.verificator").is(":checked") ) {
          $(".collapse").not(".current-user-bug").removeClass("in").addClass("out");
        }
      });

      //restore checkboxes form cookies
      $(".stats-checkbox").not(".verificator").each(function() {
        if(readCookie("show_" + this.id) == 'false'){
          this.click();
        };
      });
      if(readCookie("show_verificator") == 'true'){
        $(".stats-checkbox.verificator").click();
      };

      //apply new status icon in build list
      var build = $(".stats-title td.build-number").text().trim().substr(0, 4);
      $(".build-row." + build + " img").attr("src", asset_path($("#large-status-icon").attr("class") + ".png")).hide().show();
    })
    .ajaxError(function(){
      $('#loading-indicator').replaceWith("<div style='margin-left: -200px'>WHOOPS!! Looks like something went wrong. :( <br><a href='javascript:history.go(0)'><b>Try again</b></a> later, please.</div>");
    });
});
