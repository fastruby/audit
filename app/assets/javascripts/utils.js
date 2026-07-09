// Smooth scroll behaviour — delegated from `document` so it binds once
// regardless of script load order.
$(document).on('click', 'a.scrollto', function(event) {
  var hash = this.hash;
  event.preventDefault();
  var menuHeight = $('header').outerHeight();
  $('html, body').animate({
    scrollTop: $(hash).offset().top - menuHeight
  }, 800);
});

// Hide the "read more" toggle when an advisory description isn't clipped.
// Runs on DOM ready (fires on each full page load).
function initReadMoreToggles() {
  $('.results-content').each(function() {
    var advisoryDescriptionHeight = $('.advisory-description', this).outerHeight();
    var advisoryDescriptionContentHeight = $('.advisory-description .advisory-description-content', this).outerHeight();
    var collapseButton = $('.btn-readmore', this);

    if (advisoryDescriptionHeight >= advisoryDescriptionContentHeight) {
      collapseButton.hide();
    }
  });
}
$(initReadMoreToggles);
