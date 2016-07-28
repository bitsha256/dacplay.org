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

  action_url = 'https://bitshares-play.us9.list-manage.com/subscribe/post?u=c483312cc24bc3fbae29fadcf&amp;id='
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
    display_percentage = Math.floor((today - @dates.st_of_cf) / (@dates.ed_of_cf - @dates.st_of_cf) * 100)

  # funding completed
  display_percentage = 100
  today_percentage = 100

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


`
comify_re = /(\d{1,3})(?=(\d{3})+(?:$|\.))/g;
function display_currency(val,new_cur,precision){
  parts = val.toString().split('.');
  if (parts.length < 2) parts.push("0")
  return parts[0].replace(comify_re, "$1,") + '<small class="num">.'+max_digit(parts[1],precision)+' '+String(new_cur).split('_').join(' / ').toUpperCase()+'</small>'
}

function max_digit(d, precision){
  var p = precision || 8;
  return String(d).substring(0,p);
}`

get_play_total_donated = ->
  @dates =
    ann_of_cf: new Date(Date.UTC(2014,10,30)) # '2014-11-24 00:00:00'
    st_of_cf: new Date(Date.UTC(2015,0,5)) #'2015-01-05 00:00:00'
    ed_of_cf: new Date(Date.UTC(2015,1,2)) #'2015-02-02 00:00:00'
    today: new Date()


  st_percentage = Math.floor((dates.st_of_cf - dates.ann_of_cf) / (dates.ed_of_cf - dates.ann_of_cf) * 100)
  today_percentage = Math.floor((dates.today - dates.ann_of_cf) / (dates.ed_of_cf - dates.ann_of_cf) * 100)

  $('.cf_stat').show()
  $('#cf_raised').html display_currency('2396.11','BTC')

  # $.ajax
  #   url: 'http://www1.agsexplorer.com/total/play.json',
  #   dataType: 'jsonp'
  # .done (data) ->
  #   total = data.total / 100000000
  #   fund_percent = total / 3000 * 100
  #
  #   $('.cf_stat').show()
  #   $('#cf_raised').html display_currency(total,'BTC')

get_latest_downloads = ->
  $.ajax
    url: 'https://download.dacplay.org/downloads/latest.json',
    dataType: 'json'
  .done (data) ->
    platformCount = data.downloads.length
    colCls = parseInt(12 / platformCount)

    for i in [0...platformCount]
      d = data.downloads[i]
      platform = d.platform.split(' ')[0].toLowerCase()
      dlDiv = $("<div class='col-md-#{colCls} animated fadeInUp'><img class='platform-icon' src='../img/icon-#{platform}.svg' /><h3>#{d.platform}</h3><p style='font-size:10px;'>sha1hash: #{d.sha1hash}<br />Size: #{d.fileSize}</p><a class='btn btn#{i} withripple' href='#{d.url}' role='button' data-platform='#{d.platform}' data-version='#{data.version}'><img src='../img/ic_cloud_download_48px.svg' /><div class='ripple-wrapper'></div></a></div>")

      vendor_prop_set(dlDiv, 'animation-delay', 0.5 + i * 0.1 + 's')

      $('#download .downloads-container').append dlDiv

      $("#download .downloads-container .btn#{i}").on 'click', ->
        ga("send", "event", "client", "download", $(this).data('platform'), $(this).data('version'))

    $('#download').removeClass('hide')
    $('#download .release-intro').html "#{data.name}<br />version: #{data.version}"


get_news = (lang) ->
  url = "../news/news-#{lang}.json"
  $.ajax
    url: url,
    dataType: 'json'
  .done (data) ->
    return if !data or data.length == 0

    $('#news').show()

    for news in data
      template = "<div class='news-item'><div class='container'><div class='col-md-3'><div class='news-date text-right'>#{news['date']}</div></div><div class='col-md-9'><h3 class='news-title'>#{news['title']}</h3><div class='news-body'><p>#{news['body']}</p></div></div></div></div>"
      $('#news section .news-container').append(template)



(->
  # navigation
  $('.page-nav > li > a').each setup_page_nav_links

  # $('body').scrollspy target: "#page-nav-scrollnav", offset: 30
  # $('body').scrollspy target: ".global-nav", offset: -0

  get_latest_downloads()

  $('[data-toggle="popover"]').popover()

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

  # load news
  get_news(lang);

  # bg image
  # $.backstretch("../img/soldierf.jpg");
  # $.backstretch("../img/soldierh.jpg");

  # Progress bar
  # $('.progress [data-toggle="tooltip"]').tooltip();

  get_play_total_donated()

  # display donating btc address
  if @dates.today > @dates.st_of_cf
    $('.risk-notify-container').show()

  $('.risk_confirm_btn').on 'click', ->
    $('.risk-notify').hide()
    $('.btc-address-holder').show()

).call this;

