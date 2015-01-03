vendor_prop_set = (elem, prop, val) ->
  for vendor in ['webkit','moz','o','']
    prop = if vendor == ''
      prop
    else
      '-' + vendor + '-' + prop

    $(elem).css(prop, val)

setup_page_nav_links = (idx, elem) ->
  vendor_prop_set(this, 'animation-delay', 0.5 + idx * 0.1 + 's')
  $(elem).addClass 'animated fadeInDown'
  .click (evt) ->
    href = $(this).attr 'href'
    return if !href.match /^#/

    evt.preventDefault
    y = $(href).offset().top - 77

    $("html, body").animate scrollTop: y, 1000, jQuery.easing['easeInOutQuad']

setup_check_point = ->
  $(this).css('opacity', '').addClass("animated").addClass($(this).data('animate'))
  if $(this).data('delay')
    vendor_prop_set(this, 'animation-delay', $(this).data('delay')+'s')

subscribe_to_list = ->
  if $('#inputEmail').val() == '' || !($('#inputEmail').val().match /^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/)
    $('#inputEmail').focus().parentsUntil('.form-group').parent().addClass('has-error')
    return false
  else
    $('#inputEmail').parentsUntil('.form-group').removeClass('has-error')

  action_url = 'http://bitshares-play.us9.list-manage.com/subscribe/post?u=c483312cc24bc3fbae29fadcf&amp;id='
  list_en = action_url + '3ea6699589'
  list_cn = action_url + 'ebfabcbaec'

  $('#mailing_list').attr('action', if $('#langPrefCN').prop('checked') then list_cn else list_en )
  return true

show_progress_bar = ( start_percentage, today_percentage, dates ) ->
  today_selector = '.progress .bar'
  ready_selector = '.progress .ready-point'
  start_selector = '.progress .start-point'
  end_selector = '.progress .end-point'


  $( ready_selector )
    .css('left', '-' + $( ready_selector).width() + 'px')
    .show()
    .animate left: 0, 1000, show_tip

  $( start_selector )
    .css('left', '-' + $( start_selector).width() + 'px')
    .show()
    .animate left: ($('.progress').width() * start_percentage / 100), 1000, show_tip

  today = new Date()
  if today < @dates.st_of_cf
    display_percentage = Math.floor((today - @dates.ann_of_cf) / (@dates.st_of_cf - @dates.ann_of_cf) * 100)
  else
    display_percentage = today_percentage

  $( today_selector  )
    .data('percentage', today_percentage)
    .data('tip', today.toLocaleDateString() + ' ' + today.toLocaleTimeString())
    .animate width: today_percentage+'%', 1500, show_tip
    .find('div').html(display_percentage+'%')

  $( end_selector  )
    .css('right', '-' + $( start_selector).width() + 'px')
    .show()
    .animate right: 0, 1000, show_tip

show_tip = ->
  if $(this).data('tip')
    # if today marker, left calculation is bit different
    if $(this).hasClass('bar')
      left = $(this).width() - 47
      top = 75
    else
      left = $(this).position().left
      top = 55

    $('<span class="tip">'+$(this).data('tip')+'</span>')
      .appendTo( $(this).parent() ).
      css(position: 'absolute', top: top, left: left )

(->
  # navigation
  $('.page-nav > li > a').each setup_page_nav_links

  # $('body').scrollspy target: "#page-nav-scrollnav", offset: 30
  # $('body').scrollspy target: ".global-nav", offset: -0

  # feature item
  $('.feature-item').mouseover ->
    $('.feature-item').removeClass 'well'
    $(this).toggleClass 'well'

  # waypoints
  $('.animated').css('opacity', '0');
  $('.triggerAnimation').waypoint setup_check_point, offset: '80%', triggerOnce: true

  # mailing list form
  $('#mailing_list').submit subscribe_to_list
  # radio btn bug fix
  lang_pref_selector = '#mailing_list input[name=langpref]'
  $(lang_pref_selector ).on 'click', (evt) ->
    $(lang_pref_selector).prop 'checked', false
    $(this).prop 'checked', true

  # scrollup
  $.scrollUp
    scrollName: 'scrollUp', # Element ID
    topDistance: '77', # Distance from top before showing element (px)
    topSpeed: 300, # Speed back to top (ms)
    easingType: 'easeInOutQuad',
    animation: 'fade', # Fade, slide, none
    animationInSpeed: 200, # Animation in speed (ms)
    animationOutSpeed: 200, # Animation out speed (ms)
    scrollText: '', # Text for element
    scrollTrigger: '#scrollTopBtn',
    activeOverlay: false  # Set CSS color to display scrollUp active point, e.g '#00FFFF'

  # bg image
  # $.backstretch("../img/soldierf.jpg");
  # $.backstretch("../img/soldierh.jpg");

  # Progress bar
  $('.progress [data-toggle="tooltip"]').tooltip();

  @dates =
    ann_of_cf: new Date(Date.UTC(2014,10,30)) # '2014-11-24 00:00:00'
    st_of_cf: new Date(Date.UTC(2015,0,5)) #'2015-01-05 00:00:00'
    ed_of_cf: new Date(Date.UTC(2015,1,5)) #'2015-02-05 00:00:00'
    today: new Date()

  # if today < ann_of_cf
  #   #cf is not announced yet
  #   percentage = -1
  # else if today >= ann_of_cf && today < st_of_cf
  #   # announced not started yet
  #   percentage = Math.floor((today - ann_of_cf) / (st_of_cf - ann_of_cf) * 100)
  #   points = start: dd.ready, end: dd.start
  # else if today >= st_of_cf && today < ed_of_cf
  #   # cf ongoing
  #   percentage = Math.floor((today - st_of_cf) / (ed_of_cf - st_of_cf) * 100)
  #   points = start: dd.start, end: dd.end
  # else
  #   # cf finishe
  #   percentage = 100

  st_percentage = Math.floor((dates.st_of_cf - dates.ann_of_cf) / (dates.ed_of_cf - dates.ann_of_cf) * 100)
  today_percentage = Math.floor((dates.today - dates.ann_of_cf) / (dates.ed_of_cf - dates.ann_of_cf) * 100)

  setTimeout (-> show_progress_bar(st_percentage , today_percentage, dates )), 1500
).call this;
