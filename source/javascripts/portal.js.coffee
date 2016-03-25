#= require _jquery-2.1.4.min
#= require _flipsnap.js

setup_dummy = ->
  html = $('html').width();
  base = (html - 300) / 2;
  $('#dummy')
    .width(html)
    .animate({ width: base }, 'slow', 'swing');

$ ->
  $(window).resize(setup_dummy);
  $('#btn-prev').click ->
    if fs.hasPrev()
      fs.toPrev();
    else
      $('#dummy')
        .animate({ width: "+=16px" }, 125, 'linear')
        .animate({ width: "-=16px" }, 125, 'linear');
  $('#btn-next').click ->
    if fs.hasNext()
      fs.toNext();
    else
      $('#dummy')
        .animate({ width: "-=16px" }, 125, 'linear')
        .animate({ width: "+=16px" }, 125, 'linear');
  setup_dummy();
  fs = Flipsnap('.flipsnap', { distance: 300 });
