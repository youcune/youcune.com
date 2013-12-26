//= require jquery.flickable.js

$(function(){
    $('#flicable').flickable({section: '.card'});
    $(window).resize(setup);
    setup();
});

function setup(){
    var html = $('html').width();
    var base = (html - 300) / 2;
    $('#dummy')
        .width(html)
        .animate({ width: base }, 'normal');
}
