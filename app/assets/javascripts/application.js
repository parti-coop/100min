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
//= require jquery.fitvids
//= require d3
//= require d3-cloud
//= require jquery.modal
//= require jquery.mosaic

UnobtrusiveFlash.flashOptions['timeout'] = 5000;

$(function(){
  $('.js-slides-container').bxSlider({
    speed: 500,
    auto: true,
    autoStart: true,
    autoControls: true,
    startText: '재생',
    stopText: '정지',
    stopAutoOnClick: true,
    pager: true,
    touchEnabled: false
  });

  $('.js-hamburger-open').click(function(e) {
    var $header = $(e.currentTarget).closest('.js-hamburger-header');
    $header.addClass('selected');
    $('.js-hamburger-open-visible').show();
    $('.js-hamburger-open-invisible').hide();
  });
  $('.js-hamburger-close').click(function(e) {
    var $header = $(e.currentTarget).closest('.js-hamburger-header');
    $header.removeClass('selected');
    $('.js-hamburger-close-visible').show();
    $('.js-hamburger-close-invisible').hide();
  });
  $('.js-subhamburger-toggle').click(function(e) {
    var $elm = $(e.currentTarget);
    var $clicked = $(e.target);
    if($('.js-subhamburger-toggle-indicator').is(':visible')) {
      if(! $elm.find('.js-submenu').is($clicked.closest('.js-submenu'))) {
        e.preventDefault();
        if($elm.hasClass('selected')) {
          $('.js-subhamburger-toggle').removeClass('selected');
        } else {
          $('.js-subhamburger-toggle').removeClass('selected');
          $elm.addClass('selected');
        }
      }
    }
  });
  $('.js-menu-toggle').click(function(e) {
    var $header = $(e.currentTarget).closest('.js-menu-header');
    if($header.hasClass('selected')) {
      $header.removeClass('selected');
    } else {
      $header.addClass('selected');
    }
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
      e.clearSelection();
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

  $('.js-select-link').on('change', function(e) {
    var $selected_option = $(e.currentTarget).find('option:selected');
    var url = $selected_option.data('url');
    if(url) {
      location.href = url;
    }
  });

  $(document).on('click', '.js-link', function(e) {
    var href = $(e.target).closest('a').attr('href')
    if (href && href != "#") {
      return true;
    }

    e.preventDefault();
    var url = $(e.currentTarget).data("url");
    if(!url) {
      var $url_source = $($(e.currentTarget).data("url-source"));
      if($url_source.length > 0) {
        url = $url_source.data("url");
      }
    }

    if(!url) {
      return;
    }

    var type = $(e.currentTarget).data("type");
    if("remote" == type) {
      $.ajax({
        url: url,
        type: "get"
      });
    } else if($(this).data('link-target')) {
      window.open(url, $(this).data('link-target'));
    } else if (e.shiftKey || e.ctrlKey || e.metaKey) {
      window.open(url, '_blank');
    } else {
      window.location.href  = url;
    }
  });

  $('.js-dimd-open').on('click', function(e) {
    $('.js-dimd-wrap').css('display', 'block');
    var url = $(this).data('dimd-open-url');
    if(url) {
      $('.js-dimd-wrap iframe').attr('src', url + "?autoplay=1");
    }
  });

  $('.js-dimd-close').on('click', function(e) {
    $('.js-dimd-wrap').css('display', 'none');
    $('.js-dimd-wrap iframe').attr('src', '');
  });

  $('.js-fit-vids').fitVids();

  $('.js-mosaic').Mosaic();

  $('.js-auto-modal').each(function() {
    var url = $(this).data('url');
    if(url) {
      $.get(url, function(html) {
        $(html).appendTo('body').modal();
      });
    }
  });
});
