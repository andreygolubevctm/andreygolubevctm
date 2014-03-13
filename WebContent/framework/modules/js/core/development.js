;(function($, undefined){

	var meerkat = window.meerkat;

	// Refresh just the css when shift+s is pressed
	function initRefreshCSS(){
		function refreshStyles(event){
			var target = event.target,
				tagName = target.tagName.toLowerCase(),
				linkTags;

			if(!(event.shiftKey && event.which === 83)){
				return;
			}

			if(tagName === "input" || tagName === "textarea" || tagName === "select"){
				return;
			}

			linkTags = document.getElementsByTagName('link');

			//http://david.dojotoolkit.org/recss.html
			for(var i = 0; i < linkTags.length ; i++){
				var linkTag = linkTags[i];
				if(linkTag.rel.toLowerCase().indexOf('stylesheet')>=0){
					var href = linkTag.getAttribute('href');
					href = href.replace(/(&|\?)forceReload=\d+/,'');
					href = href + (href.indexOf('?')>=0?'&':'?') + 'forceReload=' + new Date().getTime();
					linkTag.setAttribute('href',href);
				}
			}
		}

		if(window.addEventListener){
			window.addEventListener('keypress', refreshStyles);
		}
	}

	// Initialise Dev helpers
	function initDevelopment() {
		if(meerkat.site.isDev === true){
			initRefreshCSS();
		}
	}

	meerkat.modules.register("development", {
		init: initDevelopment
	});

})(jQuery);