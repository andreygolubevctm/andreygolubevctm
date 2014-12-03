/*
*/

;(function($, undefined){

	var meerkat = window.meerkat,
		log = meerkat.logging.info;



	function getBaseUrl() {
		//
		// Get the base URL from the siteConfig if defined
		//
		if (meerkat.site && typeof meerkat.site.urls !== 'undefined') {
			if (typeof meerkat.site.urls.context !== 'undefined') {
				return meerkat.site.urls.context;
			}
			else if (typeof meerkat.site.urls.base !== 'undefined') {
				return meerkat.site.urls.base;
			}
		}
	}



	meerkat.modules.register('simples', {
		getBaseUrl: getBaseUrl
	});

})(jQuery);
