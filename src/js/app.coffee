
(->
  # navigation
  $('.page-nav a').each (idx, elem) ->
    $(elem).click (evt) ->
      href = $(this).attr 'href'
      return if !href.match /^#/

      evt.preventDefault
      y = $(href).offset().top - 77

      $("html, body").animate scrollTop: y, 1000, jQuery.easing['easeInOutQuad']

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
    activeOverlay: false  # Set CSS color to display scrollUp active point, e.g '#00FFFF'


).call this;
