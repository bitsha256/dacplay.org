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
  $('.page-nav li').removeClass('active')
  console.log $(this).parentsUntil('section').attr('id')
  $('.page-nav a[href=#' + $(this).parentsUntil('section').attr('id') + ']')
    .parent().addClass('active')
  $(this).css('opacity', '').addClass("animated").addClass($(this).data('animate'))
  if $(this).data('delay')
    vendor_prop_set(this, 'animation-delay', $(this).data('delay')+'s')

(->
  # navigation
  $('.page-nav a').each setup_page_nav_links

  # waypoints
  $('.animated').css('opacity', '0');
  $('.triggerAnimation').waypoint setup_check_point, offset: '80%', triggerOnce: true

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
