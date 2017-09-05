/**
 * affiliateProperties module ensures the affiliate cookie values are stored as xpaths in the journey.
 * Applied to online journey only - not call centre
 */
;(function ($, undefined) {

	/**
	 * labels: xpath and cookie names for affiliate references
	 * @type {{id: string, campaign: string, clickRef: string, cd1: string}}
	 */
	var labels = {
			id:         "affiliate_id",
			campaign:   "affiliate_campaign",
			clickRef:   "affiliate_clickref",
			cd1:        "affiliate_cd1"
	};

	/**
	 * init() trigger DOM elements to be created (online journey only)
	 */
	function init() {
		if(!meerkat.site.isCallCentreUser) {
			for (var i in labels) {
				populateDOM(labels[i]);
			}
		}
	}

	/**
	 * populateDOM ensure an element for the reference exists in the DOM and
	 * has the current value from the transaction or attempt to fallback to
	 * the cookie value
	 *
	 * @param ref
	 */
	function populateDOM(ref) {
		var affiliateProperty = null;
		if(meerkat.site.isCallCentreUser) {
			affiliateProperty = _.has(meerkat.site,ref) && !_.isEmpty(meerkat.site[ref]) ? meerkat.site[ref] : null;
		} else {
			affiliateProperty = getCookieValue(ref);
		}
		if(!_.isEmpty(affiliateProperty)) {
			var elementName = (meerkat.site.vertical === 'car' ? 'quote' : meerkat.site.vertical) + ref;
			var $affiliateProperty = $('#' + elementName);
			if ($affiliateProperty && $affiliateProperty.length) {
				$affiliateProperty.val(affiliateProperty);
			} else {
				$('#mainform').prepend($('<input/>', {
					type: 'hidden',
					id: elementName,
					name: elementName,
					value: affiliateProperty
				}));
			}
		}
	}

	/**
	 * getCookieValue returns the value of a named cookie - otherwise NULL
	 *
	 * @param ref
	 * @returns {*}
	 */
	function getCookieValue(ref) {
		var cookieStr = document.cookie;
		if (!_.isEmpty(cookieStr)) {
			var rawCookies = cookieStr.split(";");
			for (var i = 0; i < rawCookies.length; i++) {
				var cookie = $.trim(rawCookies[i]).split("=");
				if (cookie.length === 2) {
					if (cookie[0] === ref) {
						return cookie[1];
					}
				}
			}
		}
		return null;
	}

	meerkat.modules.register("affiliateProperties", {
		init: init
	});

})(jQuery);