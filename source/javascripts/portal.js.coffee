#= require jquery.flicksimple.js

# FlickSimple Object
fs = null;

setup_dummy = ->
  html = $('html').width();
  base = (html - 300) / 2;
  $('#dummy')
    .width(html)
    .animate({ width: base }, 'slow', 'swing');

$ ->
  $(window).resize(setup_dummy);
  $('#btn-prev').click ->
    fs.flickSimple().prevPage(1);
  $('#btn-next').click ->
    fs.flickSimple().nextPage(1);
  setup_dummy();
  fs = $('#flick').flickSimple({ snap: 300 });
