var setup_check_point, setup_page_nav_links, vendor_prop_set;

vendor_prop_set = function(elem, prop, val) {
  var vendor, _i, _len, _ref, _results;
  _ref = ['webkit', 'moz', 'o', ''];
  _results = [];
  for (_i = 0, _len = _ref.length; _i < _len; _i++) {
    vendor = _ref[_i];
    prop = vendor === '' ? prop : '-' + vendor + '-' + prop;
    _results.push($(elem).css(prop, val));
  }
  return _results;
};

setup_page_nav_links = function(idx, elem) {
  vendor_prop_set(this, 'animation-delay', idx * 0.1 + 's');
  return $(elem).addClass('animated fadeInDown').click(function(evt) {
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
};

setup_check_point = function() {
  $('.page-nav li').removeClass('active');
  console.log($(this).parentsUntil('section').attr('id'));
  $('.page-nav a[href=#' + $(this).parentsUntil('section').attr('id') + ']').parent().addClass('active');
  $(this).css('opacity', '').addClass("animated").addClass($(this).data('animate'));
  if ($(this).data('delay')) {
    return vendor_prop_set(this, 'animation-delay', $(this).data('delay') + 's');
  }
};

(function() {
  $('.page-nav a').each(setup_page_nav_links);
  $('.animated').css('opacity', '0');
  $('.triggerAnimation').waypoint(setup_check_point, {
    offset: '80%',
    triggerOnce: true
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
    scrollTrigger: '#scrollTopBtn',
    activeOverlay: false
  });
}).call(this);
