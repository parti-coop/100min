//= require jquery
//= require jquery_ujs
//= require activestorage
//= require jquery.bxslider
//= require unobtrusive_flash
//= require unobtrusive_flash_ui
//= require jquery.scrollTo
//= require jquery.validate
//= require jquery.validate.additional-methods
//= require jquery.validate.messages_ko
//= require tippy

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

  $('.js-user-confirm-check-all').change(function(e) {
    e.preventDefault();
    var $elm = $(e.currentTarget);

    if($elm.is(":checked")) {
      var $form = $elm.closest('form');
      $form.find('.js-user-confirm-check-all-target').prop('checked', true);
      $.scrollTo($form.find('.js-user-confirm-check-all-scroll-to'), 100);
    }
  });

  $('.js-form-validation').each(function() {
    var $form = $(this);
    var $submit = $($form.data("form-validation-submit-control"));

    var form_validator = $form.validate({
      ignore: ':hidden:not(.js-form-validation-force)',
      errorPlacement: function(error, element) {
        return true;
      },
      invalidHandler: function(event, validator) {
        var errors = validator.numberOfInvalids();
        if(errors) {
          var successList = validator.successList;
          $.each(successList, function(index, element) {
            var _popover;
            var $popover_target = $($(element).data('form-validation-error-popover-target'));
            if($popover_target.length <= 0) {
              $popover_target = $(element);
            }
            if($popover_target._tippy) {
              $popover_target._tippy.hide();
              $popover_target._tippy.destroy();
            }
          });

          var focused = false;

          var errorList = validator.errorList;
          return $.each(errorList, function(index, value) {
            if(!focused && !$(value.element).data('form-validation-prevent-error-focus')) {
              $(value.element).focus();
              focused = true;
            }

            var _popover;
            var $popover_target = $($(value.element).data('form-validation-error-popover-target'));
            if($popover_target.length <= 0) {
              $popover_target = $(value.element);
            }

            if($popover_target[0]._tippy) {
              var tippy_instance = $popover_target[0]._tippy;
            } else {
              var tippy_instance = tippy.one($popover_target[0], {
                arrow: true
              });
            }

            if(tippy_instance) {
              tippy_instance.setContent(value.message);
              tippy_instance.show();
            }
          });
        }
      },
      focusInvalid: false
    });

    $submit.removeClass('active');
    var form_callback = function() {
      if(form_validator.checkForm()) {
        $submit.addClass('active');
      } else {
        $submit.removeClass('active');
      }
    }
    form_callback();

    $form.find(':input').on('input', function(e) {
      form_callback();
    });

    $form.find(':input').on('change', function(e) {
      form_callback();
    });

    $form.find('select').on('change', function(e) {
      form_callback();
    });

    $form.find(':input').on('parti-need-to-validate', function(e) {
      form_callback();
    });

    $form.on('parti-need-to-validate', function(e) {
      form_callback();
    });
  });
});
