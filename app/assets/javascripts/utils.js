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

  $('.results-content').each(function(e){
		
		var advisoryDescriptionHeight = $('.advisory-description', this).outerHeight();
		var advisoryDescriptionContentHeight = $('.advisory-description .advisory-description-content', this).outerHeight();
		var collapseButton = $('.btn-readmore', this);

		if(advisoryDescriptionHeight >= advisoryDescriptionContentHeight){
			collapseButton.hide();
		}
  })
  
});
