@toggle_tags = (obj) ->
  tmp = $(obj)
  if(tmp.html() == '+')
    tmp.html('-')
    tmp.parent().parent().children('.h').show()
  else
    tmp.html('+')
    tmp.parent().parent().children('.h').hide()
@to = (url) ->
  window.location = window.location.protocol + '//' + window.location.host + url
