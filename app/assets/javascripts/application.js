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
//= require tooltipster.bundle
//= require tinymce-jquery
//= require clipboard

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

  $('.js-menu-open').click(function(e) {
    var $header = $(e.currentTarget).closest('.js-menu-open-header');
    $header.addClass('selected');
    $header.find('.js-menu-open-visible').show();
  });
  $('.js-menu-close').click(function(e) {
    var $header = $(e.currentTarget).closest('.js-menu-open-header');
    $header.removeClass('selected');
    $header.find('.js-menu-open-visible').hide();
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
            if($popover_target.hasClass('tooltipstered')) {
              $popover_target.tooltipster('destroy');
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

            if($popover_target.hasClass('tooltipstered')) {
            } else {
              $popover_target.tooltipster({})
            }
            $popover_target.tooltipster('content', value.message).tooltipster('open');
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

  //clipboard
  $('.js-clipboard').each(function() {
    var clipboard = new Clipboard(this);

    var self = this;
    clipboard.on('success', function(e) {
      $(self)
        .tooltipster({})
        .tooltipster('content', '복사되었습니다')
        .tooltipster('open')
        .tooltipster('instance').on('off', function(e) {
          if($(e.currentTarget).tooltipster('instance')) {
            $(e.currentTarget).tooltipster('destroy');
          }
        });
    });
  });

  $('.js-upload-file-title').each(function() {
    var $name_input = $(this);
    var $form = $name_input.closest('form');
    var target_name = $name_input.data('upload-file-titie-target-name');
    var $file_input = $form.find('input[type="file"][name="' + target_name + '"]');

    $file_input.on('change', function(e) {
      var file_name = e.currentTarget.files[0].name;
      $name_input.val(file_name);
    });

    $name_input.on('click', function(e) {
      $file_input.trigger('click');
    });
  });
});
