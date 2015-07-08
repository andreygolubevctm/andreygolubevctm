//
// Confirmation Module
//
;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info;



	function init() {

		$(document).ready(function() {

			if (typeof meerkat.site === 'undefined') return;
			if (meerkat.site.pageAction !== 'confirmation') return;


			// Handle error display
			// 'confirmationData' is a global object added by slide_confirmation.tag
			if (confirmationData.hasOwnProperty('confirmation') === false || confirmationData.confirmation.hasOwnProperty('flexOpportunityId') === false) {
				var message = 'Trying to load the confirmation page failed';
				if (confirmationData.hasOwnProperty('confirmation') && confirmationData.confirmation.hasOwnProperty('message')) {
					message = confirmationData.confirmation.message;
				}

				meerkat.modules.errorHandling.error({
					message: message,
					page: "homeloanConfirmation.js module",
					description: "Invalid data",
					data: null,
					errorLevel: "warning"
				});

			// Handle normal display
			} else {
				var data = confirmationData.confirmation;

				fillTemplate(data);

				meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
					method: 'completedApplication',
					object: {
						productID: ((data.product && data.product.id) ? data.product.id : null),
						productBrandCode: ((data.product && data.product.lender) ? data.product.lender : null),
						quoteReferenceNumber: data.flexOpportunityId,
						verticalFilter: (data.hasOwnProperty('situation') ? data.situation : null),
						transactionID: confirmationTranId || null,
						vertical: meerkat.site.vertical
					}
				});

			}

		});

	}

	function fillTemplate(obj) {
		var confirmationTemplate = $("#confirmation-template").html();
		if(confirmationTemplate.length) {
			var htmlTemplate = _.template(confirmationTemplate);
			var htmlString = htmlTemplate(obj);
			$("#confirmation").html(htmlString);
		}
	}

	meerkat.modules.register('homeloanConfirmation', {
		init: init
	});

})(jQuery);