// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require turbolinks
//= require_tree .
//= require clipboard


var url = document.location.href;

var clipboard = new Clipboard('.clipboard-btn', {
  text: function() {

    return url;
  }
});

$('.clipboard-btn').tooltip({
  trigger: 'click',
  placement: 'bottom'
});


function setTooltip(btn, message) {
  $(btn).tooltip('hide')
  .attr('data-original-title', message)
  .tooltip('show');
}

function hideTooltip(btn) {
  setTimeout(function() {
    $(btn).tooltip('hide');
  }, 1000);
}

clipboard.on('success', function(e) {
  setTooltip(e.trigger, 'Copied!');
  hideTooltip(e.trigger);
});

clipboard.on('error', function(e) {
  setTooltip(e.trigger, 'Failed!');
  hideTooltip(e.trigger);
});

// Custom file upload input functionality
$('#gemfile_file').on('change', function(e){
  var fileName = e.target.value.split( '\\' ).pop();
  $('.file-custom').text(fileName);
  $('.check_button').removeAttr("disabled");
})

$(document).scroll(function(){

  var headerWelcomeHeight = $(".header").outerHeight();
  var scrollTop = $(document).scrollTop();

  if(scrollTop >= headerWelcomeHeight){
    $("header").addClass("fixed");
  }else{
    $("header").removeClass("fixed");
  }

})
// Toggle button for menu in mobile
$("#mobile-menu").on('click', function(e) {
  e.preventDefault();
  $("#navbar").toggleClass("open");
})
// Closes menu on mobile when clicking a menu item
$('#menu a').on('click', function() {
  $("#navbar").removeClass("open");
})
// Hide check another Gemfile on home
if( $('.main #header_vulnerabilities').length ){
  $('body').addClass('vulnerabilities_page')
}else if( $('.main #header_privacy').length ){
  $('body').addClass('privacy_page')
}