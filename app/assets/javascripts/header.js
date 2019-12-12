// All header behaviours
$(document).on('turbolinks:load', function() {
  // Navbar toggle button
  $('.navbar-toggler').click(function(){
    $(this).toggleClass('open');
    $('.cta').toggleClass('show');
    $('header').toggleClass('open');
  });

  // Makes navbar sticky on load if scrollTop >= topSectionHeight
  var topSectionHeight = $('.top-section').outerHeight() / 2;
  var scrollTop = $(document).scrollTop();
  if(scrollTop >= topSectionHeight){
    $('header').addClass('fixed');
    $('.cta').addClass('show');
  }

  // Makes navbar sticky on scroll if scrollTop >= topSectionHeight
  $(document).scroll(function(){

    var topSectionHeight = $('.top-section').outerHeight() / 2;
    var scrollTop = $(document).scrollTop();

    if(scrollTop >= topSectionHeight){
      $('header').addClass('fixed');
    }else if($('.navbar-collapse').hasClass('in')){
      $('header').addClass('fixed');
    }
    else{
      $('header').removeClass('fixed');
    }

  })

  // Closes menu on mobile when clicking a menu item
  $('.navbar-nav a').on('click', function() {
    $('.navbar-toggler').removeClass('open');
    $('.navbar-collapse').removeClass('in');
    $('.navbar-toggler').addClass('collapsed');
  })
})
