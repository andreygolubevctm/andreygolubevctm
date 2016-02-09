/**
 * Description: External documentation:
 */

(function($, undefined) {

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info;

	var moduleEvents = {};

	var elements = {
			fsg:			"#quote_fsg",
			marketing:		"#quote_contactFieldSet input[name='quote_contact_marketing']",
			oktocall:		"#quote_contactFieldSet input[name='quote_contact_oktocall']",
			privacy:		"#quote_privacyoptin",
			terms:			"#quote_terms",
			phone:			"#quote_contact_phoneinput",
			phoneRow:		"#contactNoRow",
			emailRow:		"#contactEmailRow",
			email:			"#quote_contact_email"
	};

	function toggleValidation() {
		var isMobile = meerkat.modules.performanceProfiling.isMobile();
		var isMDorLG = _.indexOf(['lg','md'], meerkat.modules.deviceMediaState.get()) !== -1;
		if(!isMobile && isMDorLG) {
			$(elements.marketing).removeRule('validateOkToEmailRadio').setRequired(true);
			$(elements.oktocall).removeRule('validateOkToCallRadio').setRequired(true);
		}
	}

	function validateOptins() {
		var $mkt = $(elements.marketing);
		var $otc = $(elements.oktocall);
		if(!$mkt.is(':checked')) {
			$mkt.filter("input[value=N]").prop("checked",true).change();
		}
		if(!$otc.is(':checked')) {
			$otc.filter("input[value=N]").prop("checked",true).change();
		}
	}

	function addChangeListeners() {
		$(elements.oktocall).on('change', onOkToCallChanged);
		$(elements.marketing).on('change', onOkToEmailChanged);
		$(elements.privacy).on('change', onTermsOptinChanged);
		$(elements.phone).on('change', onPhoneChanged);
		$(elements.email).on('change', onEmailChanged);
	}

	function onPhoneChanged(){
		if($(elements.oktocall).closest('.row-content').hasClass('has-error')) {
			_.defer(function(){
				$(elements.oktocall).valid();
			});
		}
	}

	function onOkToCallChanged(){
		if (getValue(elements.oktocall) !== 'Y') {
			$row = $(elements.phoneRow);
			$row.find(".has-error").removeClass('has-error');
			$row.find(".error-field").empty().hide();
		}
	}

	function onEmailChanged(){
		if($(elements.marketing).closest('.row-content').hasClass('has-error')) {
			_.defer(function(){
				$(elements.marketing).valid();
			});
		}
	}

	function onOkToEmailChanged(){
		if (getValue(elements.marketing) !== 'Y') {
			$row = $(elements.emailRow);
			$row.find(".has-error").removeClass('has-error');
			$row.find(".error-field").empty().hide();
		}
	}

	function onTermsOptinChanged(){
		var optin = getValue(elements.privacy);
		$(elements.fsg).val(optin);
		$(elements.terms).val(optin);
	}

	function dump() {
		meerkat.logging.debug("optin data", {
			oktocall:		getValue(elements.oktocall),
			privacy:		getValue(elements.privacy),
			marketing:		getValue(elements.marketing),
			fsg:			$(elements.fsg).val(),
			terms:			$(elements.terms).val()
		});
	}

	function getValue(elementId) {
		var $element = $(elementId);

		if ($element.first().attr('type') === 'radio' ) {
			return ($element.filter(':checked').val() === 'Y') ? 'Y' : 'N';
		}

		return $element.is(":checked") ? "Y" : "N";
	}

	function initCarContactOptins() {

		$(document).ready(function() {

			// Only init if purple, monkey dishwasher... obviously...
			if (meerkat.site.vertical !== "car")
				return false;

			addChangeListeners();

			toggleValidation();

			dump();
		});

	}

	meerkat.modules.register("carContactOptins", {
		init : initCarContactOptins,
		events : moduleEvents,
		validateOptins : validateOptins,
		dump: dump
	});

})(jQuery);