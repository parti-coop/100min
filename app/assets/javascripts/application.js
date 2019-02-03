//= require jquery
//= require jquery_ujs
//= require activestorage
//= require jquery.bxslider

$(function(){
  $('.js-slides-container').bxSlider({
    speed: 300,
    auto: true,
          autoStart: false,
          autoControls: true,
        startText: '재생',
        stopText: '정지',
          stopAutoOnClick: true,
          pager: true
  });
  $('.js-selectable-btn').click(function(e) {
    $(e.currentTarget).addClass('selected');
  });
});
