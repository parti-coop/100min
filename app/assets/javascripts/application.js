//= require jquery
//= require jquery_ujs
//= require activestorage
//= require jquery.bxslider
//= require unobtrusive_flash
//= require unobtrusive_flash_ui

UnobtrusiveFlash.flashOptions['timeout'] = 200000;

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

  $('.js-dropdown-btn').click(function(e) {
    e.preventDefault();

    var $elm = $(e.currentTarget);
    var $dropdown = $elm.closest('.js-dropdown');
    var $menu = $dropdown.find('.js-dropdown-menu');
    if($menu.is(':visible')) {
      $menu.stop(true, true).slideUp(200);
    } else {
      $menu.stop(true, true).slideDown(200);
    }
  });
});
