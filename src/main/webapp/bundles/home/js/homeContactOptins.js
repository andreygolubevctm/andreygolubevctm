/**
 * Description: External documentation:
 */

(function($, undefined) {

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info;

	var moduleEvents = {};

	var elements = {
		fsg:			"#home_fsg",
		marketing:		"#home_policyHolder_marketing",
		oktocall:		"#home_policyHolder_oktocall",
		privacy:		"#home_privacyoptin",
		terms:			"#home_terms",
		phone:			"#home_policyHolder_phoneinput",
		email:			"#home_policyHolder_email",
		termsAccepted:	"#home_termsAccepted"
	};

	function addChangeListeners() {
		$(elements.termsAccepted).on('change', onSingleOptinChanged);
	}

	function onSingleOptinChanged(){
		var optin = getValue(elements.termsAccepted);
		$(elements.fsg).val(optin);
		$(elements.terms).val(optin);
		$(elements.marketing).val(optin);
		$(elements.oktocall).val(optin);
		$(elements.privacy).val(optin);
	}

	function dump() {
		meerkat.logging.debug("optin data", {
			privacy:		getValue(elements.privacy),
			oktocall:		getValue(elements.oktocall),
			marketing:		getValue(elements.marketing),
			fsg:			getValue(elements.fsg),
			terms:			getValue(elements.terms)
		});
	}

	function getValue(elementId) {
		var $element = $(elementId);
		if ($element.first().attr('type') === 'radio' ) {
			return ($element.filter(':checked').val() === 'Y') ? 'Y' : 'N';
		} else if($element.first().attr('type') === 'hidden'){
			return $element.val();
		} else {
			return $element.is(":checked") ? "Y" : "N";
		}
	}

	function initHomeContactOptins() {

		$(document).ready(function() {

			// Only init if purple, monkey dishwasher... obviously...
			if (meerkat.site.vertical !== "home")
				return false;

			addChangeListeners();

			dump();
		});

	}

	meerkat.modules.register("homeContactOptins", {
		init : initHomeContactOptins,
		events : moduleEvents,
		dump: dump
	});

})(jQuery);