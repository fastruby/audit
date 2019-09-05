$(document).on('turbolinks:load', function() {
  // Smooth scroll behaviour
  $('a.scrollto').on('click', function(event) {

    var hash = this.hash;
    event.preventDefault();
    var menuHeight = $('header').outerHeight();
    $('html, body').animate({
      scrollTop: $(hash).offset().top - menuHeight
    }, 800);

  });
});
// var url = document.location.href;
// 
// var clipboard = new Clipboard('.clipboard-btn', {
//   text: function() {
// 
//     return url;
//   }
// });
// 
// $('.clipboard-btn').tooltip({
//   trigger: 'click',
//   placement: 'bottom'
// });
// 
// function setTooltip(btn, message) {
//   $(btn).tooltip('hide')
//   .attr('data-original-title', message)
//   .tooltip('show');
// }
// 
// function hideTooltip(btn) {
//   setTimeout(function() {
//     $(btn).tooltip('hide');
//   }, 1000);
// }
// 
// clipboard.on('success', function(e) {
//   setTooltip(e.trigger, 'Copied!');
//   hideTooltip(e.trigger);
// });
// 
// clipboard.on('error', function(e) {
//   setTooltip(e.trigger, 'Failed!');
//   hideTooltip(e.trigger);
// });