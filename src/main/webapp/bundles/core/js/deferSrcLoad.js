/**
* Description: Waits for the page to load and then loads of all the images src that have been set with data-src instead of src. This has for effect to increase the initial page load
*/

;(function($){

	var meerkat = window.meerkat;

	function init(){

		jQuery(document).ready(function($) {
			$(window).load(function() {
				$("[data-defer-src]").each(function allDeferSrcLoadLoop(){
					var $this = $(this);
					$this.attr('src', $this.attr('data-defer-src')).removeAttr('data-defer-src');
				});
			}); 
		});

	}

	meerkat.modules.register("deferSrcLoad", {
		init: init
	});

})(jQuery);