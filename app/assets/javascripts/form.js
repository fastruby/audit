// Custom file upload input functionality
$(document).on('turbolinks:load', function() {

	$('.new_gemfile').on('change', function(e){
	  var fileName = e.target.value.split( '\\' ).pop();
	  $('.file-custom').text(fileName);
	  $('.file-custom').css('color', '#222');
	  $('.check_button').removeAttr('disabled');
	  $('.check_button').show();
	  $('.file-upload').hide();
	})

	$('.edit_gemfile').on('change', function(e){
	  var fileName = e.target.value.split( '\\' ).pop();
	  $('.file-custom').text(fileName);
	  $('.file-custom').css('color', '#222');
	  $('.check_button').removeAttr('disabled');
	  $('.check_button').show();
	  $('.file-upload').hide();
	})
	
})
