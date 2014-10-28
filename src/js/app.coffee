vendor_prop_set = (elem, prop, val) ->
  for vendor in ['webkit','moz','o','']
    prop = if vendor == ''
      prop
    else
      '-' + vendor + '-' + prop

    $(elem).css(prop, val)

setup_page_nav_links = (idx, elem) ->
  vendor_prop_set(this, 'animation-delay', 1+idx * 0.1 + 's')
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
  if $('#inputEmail').val() == '' || !($('#inputEmail').val().match /^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$/)
    $('#inputEmail').focus().parentsUntil('.form-group').parent().addClass('has-error')
    return false
  else
    $('#inputEmail').parentsUntil('.form-group').removeClass('has-error')

  action_url = 'http://bitshares-play.us9.list-manage.com/subscribe/post?u=c483312cc24bc3fbae29fadcf&amp;id='
  list_en = action_url + '3ea6699589'
  list_cn = action_url + 'ebfabcbaec'

  $('#mailing_list').attr('action', if $('#langPrefCN').prop('checked') then list_cn else list_en )
  return true

(->
  # navigation
  $('.page-nav a').each setup_page_nav_links

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


).call this;
