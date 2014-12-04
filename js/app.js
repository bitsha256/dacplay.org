var setup_check_point, setup_page_nav_links, show_progress_bar, show_tip, subscribe_to_list, vendor_prop_set;

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
  vendor_prop_set(this, 'animation-delay', 0.5 + idx * 0.1 + 's');
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
  $(this).css('opacity', '').addClass("animated").addClass($(this).data('animate'));
  if ($(this).data('delay')) {
    return vendor_prop_set(this, 'animation-delay', $(this).data('delay') + 's');
  }
};

subscribe_to_list = function() {
  var action_url, list_cn, list_en;
  if ($('#inputEmail').val() === '' || !($('#inputEmail').val().match(/^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/))) {
    $('#inputEmail').focus().parentsUntil('.form-group').parent().addClass('has-error');
    return false;
  } else {
    $('#inputEmail').parentsUntil('.form-group').removeClass('has-error');
  }
  action_url = 'http://bitshares-play.us9.list-manage.com/subscribe/post?u=c483312cc24bc3fbae29fadcf&amp;id=';
  list_en = action_url + '3ea6699589';
  list_cn = action_url + 'ebfabcbaec';
  $('#mailing_list').attr('action', $('#langPrefCN').prop('checked') ? list_cn : list_en);
  return true;
};

show_progress_bar = function(start_percentage, today_percentage, dates) {
  var end_selector, ready_selector, start_selector, today, today_selector;
  today_selector = '.progress .bar';
  ready_selector = '.progress .ready-point';
  start_selector = '.progress .start-point';
  end_selector = '.progress .end-point';
  $(ready_selector).css('left', '-' + $(ready_selector).width() + 'px').show().animate({
    left: 0
  }, 1000, show_tip);
  $(start_selector).css('left', '-' + $(start_selector).width() + 'px').show().animate({
    left: $('.progress').width() * start_percentage / 100
  }, 1000, show_tip);
  today = new Date();
  $(today_selector).data('percentage', today_percentage).data('tip', today.toLocaleDateString() + ' ' + today.toLocaleTimeString()).animate({
    width: today_percentage + '%'
  }, 1500, show_tip).find('div').html(today_percentage + '%');
  return $(end_selector).css('right', '-' + $(start_selector).width() + 'px').show().animate({
    right: 0
  }, 1000, show_tip);
};

show_tip = function() {
  var left, top;
  if ($(this).data('tip')) {
    if ($(this).hasClass('bar')) {
      left = $(this).width() - 47;
      top = 75;
    } else {
      left = $(this).position().left;
      top = 55;
    }
    return $('<span class="tip">' + $(this).data('tip') + '</span>').appendTo($(this).parent()).css({
      position: 'absolute',
      top: top,
      left: left
    });
  }
};

(function() {
  var dates, lang_pref_selector, st_percentage, today_percentage;
  $('.page-nav a').each(setup_page_nav_links);
  $('.feature-item').mouseover(function() {
    $('.feature-item').removeClass('well');
    return $(this).toggleClass('well');
  });
  $('.animated').css('opacity', '0');
  $('.triggerAnimation').waypoint(setup_check_point, {
    offset: '80%',
    triggerOnce: true
  });
  $('#mailing_list').submit(subscribe_to_list);
  lang_pref_selector = '#mailing_list input[name=langpref]';
  $(lang_pref_selector).on('click', function(evt) {
    $(lang_pref_selector).prop('checked', false);
    return $(this).prop('checked', true);
  });
  $.scrollUp({
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
  $('.progress [data-toggle="tooltip"]').tooltip();
  dates = {
    ann_of_cf: new Date(Date.UTC(2014, 10, 30)),
    st_of_cf: new Date(Date.UTC(2015, 0, 5)),
    ed_of_cf: new Date(Date.UTC(2015, 1, 5)),
    today: new Date()
  };
  st_percentage = Math.floor((dates.st_of_cf - dates.ann_of_cf) / (dates.ed_of_cf - dates.ann_of_cf) * 100);
  today_percentage = Math.floor((dates.today - dates.ann_of_cf) / (dates.ed_of_cf - dates.ann_of_cf) * 100);
  return setTimeout((function() {
    return show_progress_bar(st_percentage, today_percentage, dates);
  }), 1500);
}).call(this);
