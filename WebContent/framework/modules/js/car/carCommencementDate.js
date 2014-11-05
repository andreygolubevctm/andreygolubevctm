/**
 * Description: External documentation:
 */

(function($, undefined) {

	var meerkat =window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info;

	var moduleEvents = {
			COMMENCEMENT_DATE_UPDATED : "COMMENCEMENT_DATE_UPDATED"
	};

	function initCarCommencementDate() {

		var self = this;

		$(document).ready(function() {

			// Only init if CAR... obviously...
			if (meerkat.site.vertical !== "car")
				return false;

			meerkat.messaging.subscribe(moduleEvents.COMMENCEMENT_DATE_UPDATED, commencementDateUpdated);

		});

		$("#quote_options_commencementDate").attr('data-attach', 'true'); // Always allow this value to be collected even if hidden
	}

	function commencementDateUpdated( updatedDate ) {
		$('#quote_options_commencementDate').datepicker('update', updatedDate);
		_.defer(function(){ // Give datepicker to do its thang
			showModal(updatedDate);
		});
	}

	function showModal(updatedDate) {

		var $e = $('#expired-commencement-date-template');
		if ($e.length > 0) {
			templateCallback = _.template($e.html());
		}

		var obj = {updatedDate:updatedDate};

		var htmlContent = templateCallback(obj);
		var modalOptions = {
			htmlContent: htmlContent,
			hashId: 'call',
			className: 'expired-commencement-date-modal',
			closeOnHashChange: true,
			openOnHashChange: false,
			onOpen: function (modalId) {}
		};

		_.defer(function(){
			// Allow time if needed to be displayed over results content
			callbackModalId = meerkat.modules.dialogs.show(modalOptions);
		});
	}

	meerkat.modules.register("carCommencementDate", {
		init : initCarCommencementDate,
		events : moduleEvents
	});

})(jQuery);