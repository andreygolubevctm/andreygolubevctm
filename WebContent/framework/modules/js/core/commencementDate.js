/**
 * Description: External documentation:
 */

(function($, undefined) {

	var meerkat =window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info,
		expiredNoticeShown = false,
		loadQuoteModalId = false,
		pending_results_handler = false,
		settings = {
			dateField :				null,
			getResults :			null,
			updateData :			null,
			renderCompletedEvent :	null
	};

	var moduleEvents = {
			commencementDate : {
				COMMENCEMENT_DATE_UPDATED : "COMMENCEMENT_DATE_UPDATED",
				RESULTS_RENDER_COMPLETED : "RESULTS_RENDER_COMPLETED"
			}
	};

	function initCommencementDate(settingsIn) {

		settings = _.pick(settingsIn, 'dateField', 'getResults', 'updateData');

		$(document).ready(function() {

			if(!_.isEmpty(settings.dateField) && $(settings.dateField) && _.isFunction(settings.getResults)) {
				meerkat.messaging.subscribe(moduleEvents.commencementDate.COMMENCEMENT_DATE_UPDATED, commencementDateUpdated);
				meerkat.messaging.subscribe(meerkatEvents.emailLoadQuote.TRIGGERS_MODAL, triggerLoadQuoteModal);
				$(settings.dateField).attr('data-attach', 'true'); // Always allow this value to be collected even if hidden
			} else {
				// Do nothing as modules not initialised correctly with valid settings object
			}

		});
	}

	function commencementDateUpdated( updatedDate ) {
		alert(updatedDate);
		$(settings.dateField).datepicker('update', updatedDate);
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
		if(_.isFunction(settings.updateData)) {
			settings.updateData(data);
		}
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

		var originalDate = $(settings.dateField).val();

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
				$(settings.dateField + '_mobile').attr('data-msg-required', "Commencement date required");
				$(settings.dateField + '_mobile option:first').remove();
				$('#modal-commencement-date-get-quotes').on('click', function(event){
					event.preventDefault();
					var $btn = $(this);
					if($form.valid()) {
						// Update the commencement date and push to results page
						$(settings.dateField).datepicker('update', $(settings.dateField + '_mobile').val());
						meerkat.modules.dialogs.close(loadQuoteModalId);
						if(
							meerkat.modules.journeyEngine.getCurrentStep().navigationId === 'results' &&
							originalDate != $(settings.dateField).val()
						) {
							if(
								!_.isUndefined(Results.getAjaxRequest()) &&
								Results.getAjaxRequest() !== false &&
								Results.getAjaxRequest().readyState !== 4 &&
								Results.getAjaxRequest().status !== 200
							) {
								// Wait for current results request to finish then fire next request
								$btn.addClass('disabled');
								pending_results_handler = meerkat.messaging.subscribe(meerkatEvents.commencementDate.RESULTS_RENDER_COMPLETED, getFreshResults);
							} else {
								// Immediately request fresh results data
								settings.getResults();
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
				$(settings.dateField).datepicker('update', $(settings.dateField + '_mobile').val());
				loadQuoteModalId = false;
			}
		};

		meerkat.modules.dialogs.show(modalOptions);
	}

	function getFreshResults() {
		meerkat.messaging.unsubscribe(meerkatEvents.commencementDate.RESULTS_RENDER_COMPLETED, pending_results_handler);
		_.defer(settings.getResults);
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

	meerkat.modules.register("commencementDate", {
		initCommencementDate : initCommencementDate,
		events : moduleEvents
	});

})(jQuery);