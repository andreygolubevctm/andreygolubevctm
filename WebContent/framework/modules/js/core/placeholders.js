////////////////////////////////////////////////////////////////
//// Placeholder sham for oldbrowsers                       ////
////--------------------------------------------------------////
//// It's applying a bit of content over the top of inputs  ////
//// Uses placeholder.less                                  ////
////--------------------------------------------------------////
//// REQUIRES: jquery as $                                  ////
////--------------------------------------------------------////
////////////////////////////////////////////////////////////////

;(function($, undefined){

	var meerkat = window.meerkat,
		log = meerkat.logging.info,
		placeholdersSupported = Modernizr.input.placeholder;

		
	function initPlaceholderInput(){
		var $this = $(this),
			placeholder;
			
		if($this.data('fakeplaceholder') ||
			$this.is('[type=checkbox]') ||
			$this.is('[type=radio]')||
			$this.is('[type=hidden]') ||
			$this.is('[type=file]')){
			return;
		}
		
		placeholder = $('<div/>', {'class':'fakeplaceholder'});
		
		placeholder.height($this.height() - ($this.css("padding-bottom").replace('px','')))
			//.width($this.width())
			.css({
				'margin-top': $this.css("margin-top"),
				'margin-bottom': $this.css("margin-bottom"),
				'margin-left': $this.css("margin-left"),
				'margin-right': $this.css("margin-right"),
				'padding-top': $this.css("padding-top"),
				'padding-bottom': $this.css("padding-bottom"),
				'padding-left': $this.css("padding-left"),
				'padding-right': $this.css("padding-right"),
				'font-size': $this.css("font-size"),
				'line-height': $this.css("line-height"),
				'color': $this.css("color")
			})
			.data('for', $this);
		
		$this.before(placeholder.text($this.attr('placeholder'))).data('fakeplaceholder', placeholder);
		
		$this.val() && placeholder.hide();
	}
	
	function initPlaceholders(target){
		if(placeholdersSupported){
			return;
		}
		
		var inputsThatNeedPlaceholders = $(target || document).find('[placeholder]');
		
		inputsThatNeedPlaceholders.each(initPlaceholderInput);
	}

	function initPlaceholder() {
		if(placeholdersSupported){
			return;
		}
	
		initPlaceholders();
		
		$(document).on('focus.fakeplaceholder', 'input[placeholder]', function(){
			var $this = $(this),
				placeholder = $this.data('fakeplaceholder');
			
			placeholder.hide();
		}).on('blur.fakeplaceholder', 'input[placeholder]', function(){
			var $this = $(this),
				placeholder = $this.data('fakeplaceholder');
			
			!$this.val() && placeholder.show();
		}).on('click.fakeplaceholder', '.fakeplaceholder', function(){
			$(this).data('for').focus();
		});
	
		log('[Placeholder] Initialised');
	}

	function invalidatePlaceholder($this){
		placeholder = $this.data('fakeplaceholder');
		if( placeholder && placeholder.length > 0 ){
			if( $this.val() ){
				placeholder.hide();	
			}else{
				placeholder.show();
			}
		}
	}



	meerkat.modules.register('placeholder', {
		init: initPlaceholder,
		initPlaceholders: initPlaceholders,
		invalidatePlaceholder:invalidatePlaceholder
	});

})(jQuery);