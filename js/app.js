(function() {
  $('.page-nav a').each(function(idx, elem) {
    return $(elem).click(function(evt) {
      var href, y;
      href = $(this).attr('href');
      if (!href.match(/^#/)) {
        return;
      }
      evt.preventDefault;
      y = $(href).offset().top - 77;
      return $("html, body").animate({
        scrollTop: y
      }, 1000, jQuery.easing['easeInOutQuad']);
    });
  });
  return $.scrollUp({
    scrollName: 'scrollUp',
    topDistance: '77',
    topSpeed: 300,
    easingType: 'easeInOutQuad',
    animation: 'fade',
    animationInSpeed: 200,
    animationOutSpeed: 200,
    scrollText: '',
    activeOverlay: false
  });
}).call(this);
