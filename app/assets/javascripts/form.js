// Custom file upload input functionality.
// Delegated from `document` so it binds once and keeps working across full
// page loads regardless of script load order.
$(document).on('change', '.new_gemfile, .edit_gemfile', function(e) {
  var fileName = e.target.value.split('\\').pop();
  $('.file-custom').text(fileName);
  $('.file-custom').css('color', '#222');
  $('.check_button').removeAttr('disabled');
  $('.check_button').show();
  $('.file-upload').hide();
});
