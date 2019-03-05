jQuery(document).ready(function($) {
	//Masonry blocks
	$blocks = $(".posts");

	$blocks.imagesLoaded(function(){
		$blocks.masonry({
			itemSelector: '.post-container'
		});

		// Fade blocks in after images are ready (prevents jumping and re-rendering)
		$(".post-container").fadeIn();
	});
	
	$(document).ready( function() { setTimeout( function() { $blocks.masonry(); }, 500); });

	$(window).resize(function () {
		$blocks.masonry();
	});

	// Load Flexslider
    $(".flexslider").flexslider({
        animation: "slide",
        controlNav: false,
        smoothHeight: true,
        start: $blocks.masonry(),
    });

	resizeVideo(vidSelector);

	$(window).resize(function() {
		resizeVideo(vidSelector);
	});
    
	
	// When Jetpack Infinite scroll posts have loaded
	$( document.body ).on( 'post-load', function () {

		var $container = $('.posts');
		$container.masonry( 'reloadItems' );
		
		$blocks.imagesLoaded(function(){
			$blocks.masonry({
				itemSelector: '.post-container'
			});
	
			// Fade blocks in after images are ready (prevents jumping and re-rendering)
			$(".post-container").fadeIn();
		});
		
		// Rerun video resizing
		resizeVideo(vidSelector);
		
		$container.masonry( 'reloadItems' );
		
		// Load Flexslider
	    $(".flexslider").flexslider({
	        animation: "slide",
	        controlNav: false,
	        prevText: "Previous",
	        nextText: "Next",
	        smoothHeight: true   
	    });
		
		$(document).ready( function() { setTimeout( function() { $blocks.masonry(); }, 500); });

	});
	
	
});