@toggle_tags = (obj) ->
  tmp = $(obj)
  if(tmp.html() == '+')
    tmp.html('-')
    tmp.parent().parent().children('.h').show()
  else
    tmp.html('+')
    tmp.parent().parent().children('.h').hide()
