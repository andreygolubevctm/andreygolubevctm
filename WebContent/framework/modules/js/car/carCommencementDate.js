/**
 * Description: External documentation:
 */

(function($, undefined) {

	var meerkat =window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info,
		expiredNoticeShown = false,
		loadQuoteModalId = false,
		pending_results_handler = false;

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
			meerkat.messaging.subscribe(meerkatEvents.emailLoadQuote.TRIGGERS_MODAL, triggerLoadQuoteModal);

		});

		$("#quote_options_commencementDate").attr('data-attach', 'true'); // Always allow this value to be collected even if hidden
	}

	function commencementDateUpdated( updatedDate ) {
		$('#quote_options_commencementDate').datepicker('update', updatedDate);
		_.defer(function(){ // Give datepicker to do its thang
			showSimpleModal(updatedDate);
		});
	}

	function showSimpleModal(updatedDate) {

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

	function triggerLoadQuoteModal( data ) {
		_.extend(data, {
			youngDriver : $('input[name=quote_drivers_young_exists]:checked').val()
		});
		_.defer(_.bind(showLoadQuoteModal, this, data));
	}

	function showLoadQuoteModal(data) {
		// Listen for device state changes ONLY if actually rendering the modal
		meerkat.messaging.subscribe(meerkatEvents.device.STATE_ENTER_XS, _.bind(deviceStateChanged, this, true));
		meerkat.messaging.subscribe(meerkatEvents.device.STATE_LEAVE_XS, _.bind(deviceStateChanged, this, false));

		var $e = $('#edit-details-template');
		if ($e.length > 0) {
			templateCallback = _.template($e.html());
		}

		var originalDate = $('#quote_options_commencementDate').val();

		var htmlContent = templateCallback(data);
		var modalOptions = {
			htmlContent: '<div class="edit-details-wrapper expired-quote"></div>',
			hashId: 'expiredCommencementDate',
			className: 'edit-details-modal',
			closeOnHashChange: false,
			openOnHashChange: false,
			onOpen: function (modalId) {
				loadQuoteModalId = modalId;
				expiredNoticeShown = true;
				var $editDetails = $('.edit-details-wrapper', $('#' + modalId));
				$editDetails.html(htmlContent);
				meerkat.modules.contentPopulation.render('#' + modalId + ' .edit-details-wrapper');
				$('.accordion-collapse').on('show.bs.collapse', function(){
					$(this).prev('.accordion-heading').addClass("active-panel");
				}).on('hide.bs.collapse',function(){
					$(this).prev('.accordion-heading').removeClass("active-panel");
				});

				$form = $('#modal-commencement-date-form');
				setupDefaultValidationOnForm($form);
				$('#quote_options_commencementDate_mobile').attr('data-msg-required', "Commencement date required");
				$('#quote_options_commencementDate_mobile option:first').remove();
				$('#modal-commencement-date-get-quotes').on('click', function(event){
					event.preventDefault();
					var $btn = $(this);
					if($form.valid()) {
						// Update the commencement date and push to results page
						$('#quote_options_commencementDate').datepicker('update', $('#quote_options_commencementDate_mobile').val());
						meerkat.modules.dialogs.close(loadQuoteModalId);
						if(
							meerkat.modules.journeyEngine.getCurrentStep().navigationId === 'results' &&
							originalDate != $('#quote_options_commencementDate').val()
						) {
							if(
								!_.isUndefined(Results.getAjaxRequest()) &&
								Results.getAjaxRequest() !== false &&
								Results.getAjaxRequest().readyState !== 4 &&
								Results.getAjaxRequest().status !== 200
							) {
								// Wait for current results request to finish then fire next request
								$btn.addClass('disabled');
								pending_results_handler = meerkat.messaging.subscribe(meerkatEvents.carResults.RESULTS_RENDER_COMPLETED, getFreshResults);
							} else {
								// Immediately request fresh results data
								meerkat.modules.carResults.get();
							}
						}
					}
				});

				$editDetails.find('a.btn-edit').on('click', function editDetails(event){

					event.preventDefault();

					if(
						meerkat.modules.journeyEngine.getCurrentStep().navigationId === 'results' &&
						!_.isUndefined(Results.getAjaxRequest()) &&
						Results.getAjaxRequest() !== false &&
						Results.getAjaxRequest().readyState !== 4 &&
						Results.getAjaxRequest().status !== 200
					) {
						Results.getAjaxRequest().abort();
					}

					meerkat.modules.dialogs.close(loadQuoteModalId);
					meerkat.modules.journeyEngine.gotoPath($(this).attr('href').substring(1));
				});

				if(meerkat.modules.deviceMediaState.get() === "xs") {
					$editDetails.show();
				} else {
					$editDetails.find('.accordion-collapse').addClass('in').end().show();
				}
			},
			onClose: function(modalId) {
				$('#quote_options_commencementDate').datepicker('update', $('#quote_options_commencementDate_mobile').val());
				loadQuoteModalId = false;
			}
		};

		meerkat.modules.dialogs.show(modalOptions);
	}

	function getFreshResults() {
		meerkat.messaging.unsubscribe(meerkatEvents.carResults.RESULTS_RENDER_COMPLETED, pending_results_handler);
		_.defer(meerkat.modules.carResults.get);
	}

	function deviceStateChanged(enterXS) {

		enterXS = enterXS || false;

		if(loadQuoteModalId !== false && meerkat.modules.dialogs.isDialogOpen(loadQuoteModalId)) {
			var $modal = $('.edit-details-wrapper', $('#' + loadQuoteModalId));
			if(enterXS === true) {
				$modal.find('.accordion-collapse').not('.expired-panel').removeClass('in');
				$modal.find('.accordion-heading.active-panel').next('.accordion-collapse').addClass('in');
			} else {
				$modal.find('.accordion-collapse').each(function(){
					$that = $(this);
					$that.addClass('in').css({height:'auto'});
				});
			}
		}
	}

	function getExpiredNoticeShown() {
		return expiredNoticeShown;
	}

	meerkat.modules.register("carCommencementDate", {
		init : initCarCommencementDate,
		events : moduleEvents
	});

})(jQuery);