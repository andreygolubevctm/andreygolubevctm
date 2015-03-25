(function($, undefined) {

	var meerkat = window.meerkat,
	meerkatEvents = meerkat.modules.events,
	log = meerkat.logging.info;

	var moduleEvents = {
		creditcard : {

		}
	},
	$mainForm,
	product;


	function initCreditCard() {

		$(document).ready(function() {

			// Only init if creditcard
			if (meerkat.site.vertical !== "creditcard")
				return false;

			product = meerkat.site.product;

			if(typeof product === null) {
				return false;
			}

			// Journey 2 ONLY needs to do this when directly transferring.
			if(meerkat.modules.tracking.getCurrentJourney() == "2") {
				trackTransfer();
				setTimeout(function() {
					redirectTo(product, "justRedirect");
				}, 200);
				return;
			}

			$mainForm = $('#mainform');

			// Otherwise we need to validate.
			setupDefaultValidationOnForm( $mainForm );

			$('.cc-just-continue').on('click', function justContinueToPartner(e) {
				e.preventDefault();
				var $el = $(this);
				saveDetails($el).done(function() {
					redirectTo(product, "justContinueToPartner");
				}).fail(function() {
					meerkat.modules.loadingAnimation.hide($el);
					$('.cc-just-continue, .cc-submit-details').removeClass('disabled');
				});
			});

			$('.cc-submit-details').on('click', function submitDetails(e) {
				e.preventDefault();
				var $el = $(this);
				if(isValid()) {
					saveDetails($el).done(function() {
						redirectTo(product, "submitDetails");
					});
				} else {
					meerkat.modules.loadingAnimation.hide($el);
					$('.cc-just-continue, .cc-submit-details').removeClass('disabled');
					//meerkat.modules.journeyEngine.logValidationErrors();
				}
			});

			$('#creditcard_privacyoptin').on('change', function() {
				$('#creditcard_optIn').val(($(this).prop('checked') ? 'Y' : 'N'));
			});

			$('#creditcard_location').on('blur',function() {
				setLocation($(this).val());
			});


		});

	}

	function redirectTo(product, methodName) {
		if(typeof product.handoverUrl == 'string' && product.handoverUrl.length > 1) {
			window.location.replace(product.handoverUrl);
		} else {
			meerkat.modules.errorHandling.error({
				errorLevel:		'warning',
				message:		"An error occurred. Sorry about that!<br /><br />Please go back and try again.",
				page:			'creditcard.js:'+methodName,
				description:	"No handoverUrl in results object.",
				data:			product
			});
			return false;
		}
	}
	/**
	 * Submit the form, disable the buttons.
	 */
	function saveDetails($submitButton) {

		$('.cc-just-continue, .cc-submit-details').addClass('disabled');

		meerkat.modules.loadingAnimation.showInside($submitButton, true);

		trackTransfer();

		var data = meerkat.modules.journeyEngine.getSerializedFormData($("#mainform"));

		data += "&quoteType=" + meerkat.site.vertical;

		return meerkat.modules.comms.post({
			url: 'ajax/write/creditcard_submit.jsp',
			data: data,
			errorLevel: "silent"
		});

	}

	function isValid() {
		var isFormValid = true;
		$mainForm.each(function( index, element ) {
			$element = $(element);
			var formValid = $element.valid();
			if(formValid === false) isFormValid = false;
		});
		return isFormValid;
	}

	function trackTransfer() {
		meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
			method: 'trackQuoteTransfer',
			object: {
				productID: product.code,
				productBrandCode: product.provider.code,
				productName: product.shortDescription
			}
		});
	}

	function setLocation(location) {
		if( isValidLocation(location) ) {
			var value = $.trim(String(location));
			var pieces = value.split(' ');
			var state = pieces.pop();
			var postcode = pieces.pop();
			var suburb = pieces.join(' ');

			$('#creditcard_state').val(state);
			$('#creditcard_postcode').val(postcode);
			$('#creditcard_suburb').val(suburb);
		}
	}

	function isValidLocation( location ) {

		var search_match = new RegExp(/^((\s)*([^~,])+\s+)+\d{4}((\s)+(ACT|NSW|QLD|TAS|SA|NT|VIC|WA)(\s)*)$/);

		value = $.trim(String(location));

		if( value !== '' ) {
			if( value.match(search_match) ) {
				return true;
			}
		}
		return false;
	}

	meerkat.modules.register("creditcard", {
		init: initCreditCard,
		events: moduleEvents
	});

})(jQuery);