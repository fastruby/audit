// All header behaviours.
// Interactive handlers are delegated from `document` so they bind once
// regardless of script load order; the sticky-on-load state is set on DOM
// ready (fires on each full page load).

// Navbar toggle button
$(document).on('click', '.navbar-toggler', function() {
  $(this).toggleClass('open');
  $('.cta').toggleClass('show');
  $('header').toggleClass('open');
});

// Closes menu on mobile when clicking a menu item
$(document).on('click', '.navbar-nav a', function() {
  $('.navbar-toggler').removeClass('open');
  $('.navbar-collapse').removeClass('in');
  $('.navbar-toggler').addClass('collapsed');
});

// Makes navbar sticky on scroll if scrollTop >= topSectionHeight
$(document).on('scroll', function() {
  var topSectionHeight = $('.top-section').outerHeight() / 2;
  var scrollTop = $(document).scrollTop();

  if (scrollTop >= topSectionHeight) {
    $('header').addClass('fixed');
  } else if ($('.navbar-collapse').hasClass('in')) {
    $('header').addClass('fixed');
  } else {
    $('header').removeClass('fixed');
  }
});

// Makes navbar sticky on load if scrollTop >= topSectionHeight
function initHeaderStickyState() {
  var topSectionHeight = $('.top-section').outerHeight() / 2;
  var scrollTop = $(document).scrollTop();
  if (scrollTop >= topSectionHeight) {
    $('header').addClass('fixed');
    $('.cta').addClass('show');
  }
}
$(initHeaderStickyState);
