#= require _flipsnap.js

# shortcut for document.getElementById
$ = (id) ->
  document.getElementById(id)

# (re)calculate dummy item width
calc_dummy_width = ->
  $('dummy').style.width = "#{(window.innerWidth - 300) / 2}px"

# create dummy element
dummy_item = document.createElement 'div'
dummy_item.setAttribute 'id', 'dummy'
dummy_item.setAttribute 'class', 'item'
$('items').insertBefore(dummy_item, $('items').firstChild)
calc_dummy_width()
window.addEventListener 'resize', calc_dummy_width

# flipsnap
fs = Flipsnap '#items', { distance: 300 }
$('btn-prev').addEventListener 'click', ->
  fs.toPrev() if fs.hasPrev()

$('btn-next').addEventListener 'click', ->
  fs.toNext() if fs.hasNext()
