// Makes bottom bar sticky on scroll if scrollTop >= resultsPosition
  $(document).scroll(function(){

    var resultsOffset = $('.section-result').offset();
    var resultsPosition = resultsOffset && resultsOffset.top;
    var footerHeight = $('.footer').outerHeight();
    var footerPosition = $(document).height() - footerHeight
    var scrollTop = $(document).scrollTop();
    var scrollHeight = $(window).height();
    var scrollPosition = scrollTop + scrollHeight;

    if(scrollTop >= resultsPosition){
      $('#bottom-bar').addClass('fixed');
    }
    else{
      $('#bottom-bar').removeClass('fixed');
    }
    if(scrollPosition >= footerPosition){
      $('#bottom-bar').removeClass('fixed');
    }

  })