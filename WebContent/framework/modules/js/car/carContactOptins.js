/**
 * Description: External documentation:
 */

(function($, undefined) {

	var meerkat =window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info;

	var moduleEvents = {};

	var elements = {
			ctmoktocall:	"#quote_contact_ctmoktocall",
			fsg:			"#quote_fsg",
			marketing:		"#quote_contact_marketing",
			oktocall:		"#quote_contact_oktocall",
			privacy:		"#quote_privacyoptin",
			terms:			"#quote_terms",
			phone:			"#quote_contact_phone",
			phoneRow:		"#contactNoRow"
	};

	function addChangeListeners() {
		$(elements.oktocall).on('change', onOkToCallChanged);
		$(elements.privacy).on('change', onTermsOptinChanged);
	}

	function onOkToCallChanged(){
		if($(elements.oktocall).is(":checked") === false){
			$row = $(elements.phoneRow);
			$row.find(".has-error").removeClass('has-error');
			$row.find(".error-field").empty().hide();
		}
	}

	function onTermsOptinChanged(){
		var optin = getValue(elements.privacy);
		$(elements.ctmoktocall).val(optin);
		$(elements.fsg).val(optin);
		$(elements.marketing).val(optin);
		$(elements.terms).val(optin);
	}

	function dump() {
		meerkat.logging.debug("optin data", {
			oktocall:		getValue(elements.oktocall),
			privacy:		getValue(elements.privacy),
			marketing:		$(elements.marketing).val(),
			ctmoktocall:	$(elements.ctmoktocall).val(),
			fsg:			$(elements.fsg).val(),
			terms:			$(elements.terms).val()
		});
	}

	function getValue( elementId ) {
		return $(elementId).is(":checked") ? "Y" : "N";
	}

	function initCarContactOptins() {

		var self = this;

		$(document).ready(function() {

			// Only init if health... obviously...
			if (meerkat.site.vertical !== "car")
				return false;

			addChangeListeners();

			dump();
		});

	}

	meerkat.modules.register("carContactOptins", {
		init : initCarContactOptins,
		events : moduleEvents,
		dump: dump
	});

})(jQuery);