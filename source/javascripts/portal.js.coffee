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
    if fs.flickSimple('page') <= 1
      $('#dummy')
        .animate({ width: "+=16px" }, 'fast', 'linear')
        .animate({ width: "-=16px" }, 'fast', 'linear');
    else
      fs.flickSimple().prevPage(1);
  $('#btn-next').click ->
    if fs.flickSimple('page') >= 5
      $('#dummy')
        .animate({ width: "-=16px" }, 'fast', 'linear')
        .animate({ width: "+=16px" }, 'fast', 'linear');
    else
      fs.flickSimple().nextPage(1);
  setup_dummy();
  fs = $('#flick').flickSimple({ snap: 300 });
