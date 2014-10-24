cleanSource = (html) ->
  lines = html.split('\n')
  lines.shift()
  lines.splice(-1, 1)

  indentSize = lines[0].length - lines[0].trim().length
  re = new RegExp " {" + indentSize + "}"

  lines = lines.map (line) ->
    line = line.substring indentSize if line.match re
    return line

  lines = lines.join("\n");
  return lines;


$button = $("<div id='source-button' class='btn btn-primary btn-xs'>&lt; &gt;</div>").click ->
  index = $('.bs-component').index $(this).parent()
  $.get window.location.href, (data) ->
    html = $(data).find('.bs-component').eq(index).html();
    html = clearnSource html
    $('#source-modal pre').text html
    $('#source-modal').modal()

$('.bs-component [data-toggle="popover"]').popover();
$('.bs-component [data-toggle="tooltip"]').tooltip();

$(".bs-component").hover ->
  $(this).append $button
, -> $button.hide()


$(".icons-material .icon").each ->
  $(this).after("<br><br><code>" + $(this).attr("class").replace("icon ", "") + "</code>")
