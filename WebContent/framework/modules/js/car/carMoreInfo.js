(function ($, undefined) {

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events;

	var events = {
			carMoreInfo: {
				// car specific events
			}
		},
		moduleEvents = events.carMoreInfo;

	var $bridgingContainer = $('.bridgingContainer'),
		callDirectLeadFeedSent = {},
		specialConditionContent = '', // content for the special condition dialog
		hasSpecialConditions = false, // to display the special condition dialog
		callbackModalId, // the id of the currently displayed callback modal
		scrollPosition, //The position of the page on the modal display
		activeCallModal;

	/**
	 * Specify the options within here to pass to meerkat.modules.moreInfo.
	 */
	function initMoreInfo() {

		var options = {
			container: $bridgingContainer,
			hideAction: 'fadeOut',
			showAction: 'fadeIn',
			modalOptions: {
				className: 'modal-breakpoint-wide modal-tight bridgingContainer',
				openOnHashChange: false,
				leftBtn: {
					label: 'All Products',
					icon: '<span class="icon icon-arrow-left"></span>',
					callback: function (eventObject) {
						$(eventObject.currentTarget).closest('.modal').modal('hide');
					}
				}
			},
			runDisplayMethod: runDisplayMethod,
			onBeforeShowBridgingPage: onBeforeShowBridgingPage,
			onBeforeShowTemplate: renderScrapes,
			onBeforeShowModal: renderScrapes,
			onAfterShowModal: requestTracking,
			onAfterShowTemplate: onAfterShowTemplate,
			onBeforeHideTemplate: null,
			onAfterHideTemplate: onAfterHideTemplate,
			onClickApplyNow: onClickApplyNow,
			onBeforeApply: null,
			onApplySuccess: onApplySuccess,
			retrieveExternalCopy: retrieveExternalCopy,
			additionalTrackingData: {
				productName: null
			}
		};

		meerkat.modules.moreInfo.initMoreInfo(options);

		eventSubscriptions();
		applyEventListeners();
	}

	function applyEventListeners() {

		$(document).on('click', '.bridgingContainer .btn-call-actions', function (event) {
			/**
			 * Render the call modal template, set up default name values, fix height
			 */
			event.preventDefault();
			event.stopPropagation();
			var $el = $(this);
			var $e = $('#car-call-modal-template');
			if ($e.length > 0) {
				templateCallback = _.template($e.html());
			}
			var obj = meerkat.modules.moreInfo.getOpenProduct();

			// If its unavailable, don't do anything
			// This is if someone tries to fake a bridging page for a "non quote" product.
			if(obj.available !== "Y")
				return;

			activeCallModal = $el.attr('data-callback-toggle');
			var sessionCamStep = meerkat.modules.sessionCamHelper.getMoreInfoStep(activeCallModal);

			var htmlContent = templateCallback(obj);
			var modalOptions = {
				htmlContent: htmlContent,
				hashId: 'call',
				className: 'call-modal ' + obj.brandCode,
				closeOnHashChange: true,
				openOnHashChange: false,
				onOpen: function (modalId) {

					$('.' + activeCallModal).show();
					fixSidebarHeight('.paragraphedContent:visible', '.sidebar-right', $('#'+modalId));

					setupCallbackForm();

					if ($el.hasClass('btn-calldirect')) {
						recordCallDirect(event);
					} else {
						trackCallBack();// Add CallBack request event to supertag
					}

					meerkat.modules.sessionCamHelper.updateVirtualPage(sessionCamStep);

				},
				onClose: function(modalId) {
					meerkat.modules.sessionCamHelper.setMoreInfoModal();
				}
			};

			if(meerkat.modules.deviceMediaState.get() == 'xs') {
				modalOptions.title = "Reference no. " + obj.leadNo;
			}

			callbackModalId = meerkat.modules.dialogs.show(modalOptions);
		}).on('click', '.call-modal .btn-call-actions', function (event) {
			/**
			 * Just toggle between the modes here in the modal.
			 */
			if(meerkat.modules.deviceMediaState.get() != 'xs') {
				event.preventDefault();
			}
			event.stopPropagation();
			var $el = $(this);

			activeCallModal = $el.attr('data-callback-toggle');
			var sessionCamStep = meerkat.modules.sessionCamHelper.getMoreInfoStep(activeCallModal);

			switch (activeCallModal) {
			case 'calldirect':
				$('.callback').hide();
				$('.calldirect').show();
				recordCallDirect(event);
				break;
			case 'callback':
				$('.calldirect').hide();
				$('.callback').show();
				trackCallBack();// Add CallBack request event to supertag
				break;
			}

			// Fix the height of the sidebar
			fixSidebarHeight('.paragraphedContent:visible', '.sidebar-right', $el.closest('.modal.in'));

			// Update session cam virtual page
			meerkat.modules.sessionCamHelper.updateVirtualPage(sessionCamStep);

		}).on('click', '.btn-submit-callback', function (event) {
			event.preventDefault();
			var $el = $(this);
			if($el.closest('form').valid()) {
				var currentBrandCode = meerkat.site.tracking.brandCode.toUpperCase();
				callLeadFeedSave(event, {
					message: currentBrandCode+' - Car Vertical - Call me now',
					phonecallme: 'GetaCall'
				});

				trackCallBackSubmit();// Add CallBack Submit request event to supertag
			} else {
				_.delay(function() {
					fixSidebarHeight('.paragraphedContent:visible', '.sidebar-right', $el.closest('.modal.in'));
				}, 200);
			}
			return false;
		});

		$('.slide-feature-closeMoreInfo a').off().on('click', function() {
			meerkat.modules.moreInfo.close();
		});
	}

	/**
	 * Setup the form fields/values for the callback form.
	 * Also bind validation rules.
	 */
	function setupCallbackForm() {

		setupDefaultValidationOnForm( $('#getcallback') );
		//$("#getcallback").validate();
		var clientName = $('#quote_CrClientName');
		// populate client name if empty
		if (clientName.length && !clientName.val().length) {
			clientName.val($("#quote_drivers_regular_firstname").val() + " " + $("#quote_drivers_regular_surname").val());
		}

		var telNum = $('#quote_CrClientTelinput');
		// populate client number if empty
		if (telNum.length && !telNum.val().length) {
			telNum.val($('#quote_contact_phone').val());
		}
		telNum.attr('data-msg-required', "Please enter your contact number");

	}

	/**
	 * Sets a min-height on a right sidebar.
	 * @param {String} leftSelector A selector for the left container
	 * @param {String} rightSelector A selector for the right container
	 * @param {jQuery()} $container An element to provide context so it doesn't set height elsewhere.
	 */
	function fixSidebarHeight(leftSelector, rightSelector, $container) {
		if(meerkat.modules.deviceMediaState.get() != 'xs') {
		/* match up sidebar's height with left side or vice versa */
			if($(rightSelector, $container).length) {
				var leftHeight = $(leftSelector, $container).outerHeight();
				var rightHeight = $(rightSelector, $container).outerHeight();
				if(leftHeight >= rightHeight) {
					$(rightSelector, $container).css('min-height', leftHeight + 'px');
					$(leftSelector, $container).css('min-height', leftHeight + 'px');
				} else {
					$(rightSelector, $container).css('min-height', rightHeight + 'px');
					$(leftSelector, $container).css('min-height', rightHeight + 'px');
				}
			}
		}
	}
	/**
	 * Record the fact they've clicked call insurer direct.
	 * Only do this once per product, but once per session for supertag.
	 * @param {event} event The event object.
	 */
	function recordCallDirect(event) {

		// Call supertag to register event - only once per session
		trackCallDirect();// Add CallDirect request event to supertag

		var currProduct = meerkat.modules.moreInfo.getOpenProduct();
		if (typeof callDirectLeadFeedSent[currProduct.productId] != 'undefined')
			return;

		var currentBrandCode = meerkat.site.tracking.brandCode.toUpperCase();

		return callLeadFeedSave(event, {
			message: currentBrandCode+' - Car Vertical - Call direct',
			phonecallme: 'CallDirect'
		});
	}
	/**
	 * Perform the lead feed save request for both call direct and call back functions.
	 * @param {event} event The event object from the button click
	 * @param {POJO} data The data to extend into the AJAX request
	 */
	function callLeadFeedSave(event, data) {

		var currProduct = meerkat.modules.moreInfo.getOpenProduct();
		if (typeof currProduct !== 'undefined' && currProduct !== null && typeof currProduct.vdn !== 'undefined' && !_.isEmpty(currProduct.vdn) && currProduct.vdn > 0) { // VDN is a number
			data.vdn = currProduct.vdn;
		}

		var currentBrandCode = meerkat.site.tracking.brandCode.toUpperCase();

		var defaultData = {
				state: $("#quote_riskAddress_state").val(),
				brand: currProduct.productId.split('-')[0]
		};

		if(meerkat.site.leadfeed[data.phonecallme].use_disc_props) {
			$.extend(defaultData, {
				source: currentBrandCode+'CAR',
				leadNo: currProduct.leadNo,
				client: $('#quote_CrClientName').val() || '',
				clientTel: $('#quote_CrClientTelinput').val() || '',
				transactionId: meerkat.modules.transactionId.get()
			});
		} else {
			$.extend(defaultData, {
				clientNumber: currProduct.leadNo,
				clientName: $('#quote_CrClientName').val() || '',
				phoneNumber: $('#quote_CrClientTelinput').val() || '',
				partnerReference: meerkat.modules.transactionId.get()
			});
		}

		var allData = $.extend(defaultData, data);

		var $element = $(event.target);
		meerkat.modules.loadingAnimation.showInside($element, true);
		return meerkat.modules.comms.post({
			url: meerkat.site.leadfeed[data.phonecallme].url,
			data: allData,
			dataType: 'json',
			cache: false,
			errorLevel: ((data.phonecallme === 'GetaCall') ? "warning" : "silent"),
			onSuccess: function onSubmitSuccess(resultData) {
				if (data.phonecallme == 'GetaCall') {
					var modalId = meerkat.modules.dialogs.show({
						title: "Call back request recorded",
						htmlContent: "<p><strong>Thank you!</strong></p><p>Your Call request has been sent to the insurer's message centre who will be in touch as soon as possible.</p>",
						hashId: 'call-back-success',
						openOnHashChange: false,
						closeOnHashChange: true,
						onOpen: function(modalId) {
							var sessionCamStep = meerkat.modules.sessionCamHelper.getMoreInfoStep(activeCallModal + "-submitted");
							meerkat.modules.sessionCamHelper.updateVirtualPage(sessionCamStep);
						},
						onClose: function (modalId) {
							var sessionCamStep = meerkat.modules.sessionCamHelper.getMoreInfoStep(activeCallModal);
							meerkat.modules.sessionCamHelper.updateVirtualPage(sessionCamStep);

							$('.modal').modal('hide');
							if (meerkat.modules.moreInfo.isBridgingPageOpen()) {
								meerkat.modules.moreInfo.close();
							}
						}
					});
				}
			},
			onComplete: function onSubmitComplete() {
				if (data.phonecallme == 'CallDirect') {
					callDirectLeadFeedSent[currProduct.productId] = true;
				}
				meerkat.modules.loadingAnimation.hide($element);
			}
		});
	}

	function eventSubscriptions() {

		meerkat.messaging.subscribe(meerkatEvents.ADDRESS_CHANGE, function bridgingPageHashChange(event) {
			if (meerkat.modules.deviceMediaState.get() != 'xs' && event.hash.indexOf('results/moreinfo') == -1) {
				meerkat.modules.moreInfo.hideTemplate($bridgingContainer);
			}
		});

		meerkat.messaging.subscribe(meerkatEvents.device.STATE_ENTER_XS, function bridgingPageEnterXsState() {
			if (meerkat.modules.moreInfo.isBridgingPageOpen()) {
				meerkat.modules.moreInfo.close();
			}
			if(typeof callbackModalId != 'undefined') {
				$('#' + callbackModalId).modal('hide');
			}
		});

		meerkat.messaging.subscribe(meerkatEvents.device.STATE_LEAVE_XS, function bridgingPageLeaveXsState() {
			if (meerkat.modules.moreInfo.isModalOpen()) {
				meerkat.modules.moreInfo.close();
			}
			if(typeof callbackModalId != 'undefined') {
				$('#' + callbackModalId).modal('hide');
			}
		});

		meerkat.messaging.subscribe(meerkatEvents.errorHandling.OK_CLICKED, function errorHandlingOkClicked() {
			if (meerkat.modules.moreInfo.isBridgingPageOpen() || meerkat.modules.moreInfo.isModalOpen()) {
				meerkat.modules.moreInfo.close();
			}
		});
	}
	/**
	 * Set the current scroll position so that it can be used when modals are closed
	 */
	function setScrollPosition() {
		scrollPosition = $(window).scrollTop();
	}
	/**
	 * Set the view state for when your bridging page or modal is open.
	 * Called from meerkat.modules.moreInfo.openBridgingPage
	 */
	function onBeforeShowBridgingPage() {
		setScrollPosition();
		if (meerkat.modules.deviceMediaState.get() != 'xs') {
			$('.resultsContainer, #navbar-filter, #navbar-compare').hide();
		}
	}

	/**
	 * Things to do once the template is displayed.
	 * Called within meerkat.modules.moreInfo.showTemplate
	 */
	function onAfterShowTemplate() {

		requestTracking();

		if (meerkat.modules.deviceMediaState.get() == 'lg' || meerkat.modules.deviceMediaState.get() == 'md') {
			fixSidebarHeight('.paragraphedContent', '.moreInfoRightColumn', $bridgingContainer);
		}
	}
	/**
	 * Restores the original state of the view from what you changed in onBeforeShowTemplate
	 * or onBeforeShowBridgingPage (template only, not modal)
	 * Called within meerkat.modules.moreInfo.hideTemplate
	 */
	function onAfterHideTemplate() {
		$('.resultsContainer, #navbar-filter, #navbar-compare').show();
		$(window).scrollTop(scrollPosition);
	}

	/**
	 * Handles how you want to display the bridging page based on your viewport/requirements
	 */
	function runDisplayMethod(productId) {
		if (meerkat.modules.deviceMediaState.get() != 'xs') {
			meerkat.modules.moreInfo.showTemplate($bridgingContainer);
		} else {
			meerkat.modules.moreInfo.showModal();

		}
		meerkat.modules.address.appendToHash('moreinfo');
	}

	/**
	 * Retrieves the data used for the bridging page.
	 */
	function retrieveExternalCopy(product) {

		return meerkat.modules.comms.get({
			url: "ajax/json/get_scrapes.jsp",
			cache: true,
			data: {
				type: 'carBrandScrapes',
				code: product.productId,
				group: 'car'
			},
			errorLevel: "silent",
			onSuccess: function (result) {
				meerkat.modules.moreInfo.setDataResult(result);
			}
		});
	}

	/**
	 * When you click the btn-more-info-apply.
	 * Pre-dispatch checking and functionality.
	 * @param {POJO} product The selected product
	 * @param {Function} applyNowCallback - the function to run on a successful apply now click.
	 */
	function onClickApplyNow(product, applyNowCallback) {

		var is_autogeneral = product.service.search(/agis_/i) === 0;
		if(hasSpecialConditions === true && specialConditionContent.length > 0 && !is_autogeneral) {

			var $e = $('#special-conditions-template');
			if ($e.length > 0) {
				templateCallback = _.template($e.html());
			}
			var obj = meerkat.modules.moreInfo.getOpenProduct();
			obj.specialConditionsRule = specialConditionContent;

			var htmlContent = templateCallback(obj);

			var modalId = meerkat.modules.dialogs.show({
				htmlContent: htmlContent,
				hashId: 'special-conditions',
				title: 'Special Conditions Confirmation',
				closeOnHashChange: true,
				openOnHashChange: false,
				onOpen: function(modalId) {
					$('.btn-proceed-to-insurer', $('#'+modalId)).off('click.proceed').on('click.proceed', function(event) {
						event.preventDefault();
						return proceedToInsurer(product, modalId, applyNowCallback);
					});
					$('.btn-back', $('#'+modalId)).off('click.goback').on('click.goback', function(event) {
						$('.modal').modal('hide');
						if (meerkat.modules.moreInfo.isBridgingPageOpen()) {
							meerkat.modules.moreInfo.close();
						}
					});

				},
				onClose: function(modalId) {
					meerkat.modules.moreInfo.applyCallback(false);
				}
			});

			return false;
		}
		// otherwise just do it.
		return proceedToInsurer(product, false, applyNowCallback);
	}

	/**
	 * On confirmation of conditions, perform tracking and start the transfer.
	 */
	function proceedToInsurer(product, modalId, applyNowCallback) {

		if(modalId) {
			$('#'+modalId).modal('hide');
		}

		if(callbackModalId) {
			$('#'+callbackModalId).modal('hide');
		}

		if(_.isEmpty(product.quoteUrl)) {
			meerkat.modules.errorHandling.error({
				errorLevel:		'warning',
				message:		"An error occurred. Sorry about that!<br /><br /> To purchase this policy, please contact the provider " + (product.telNo !== '' ? " on " + product.telNo : "directly") + " quoting " + product.leadNo + ", or select another policy.",
				page:			'carMoreInfo.js:proceedToInsurer',
				description:	"Insurer did not provide quoteUrl in results object.",
				data:			product
			});
			// stops the propagation to the links event handler.
			return false;
		}

		meerkat.modules.partnerTransfer.transferToPartner({
			encodeTransferURL:	true,
			product:			product,
			applyNowCallback:	applyNowCallback,
			productName:		product.headline.name,
			productBrandCode:	product.brandCode,
			brand:				product.productDes
		});

		return true;
	}
	/**
	 * Performs the supertag trackBridgingClick tracking for the CrCallDir 'type'.
	 * Will only be sent to superTag once per session.
	 * As discussed with Elvin & Tim, we won't change supertag stats, but its ok
	 * to send multiple transaction detail saves.
	 */
	function trackCallDirect(){
		var i = 0;

		for(var key in callDirectLeadFeedSent) {
			if(callDirectLeadFeedSent.hasOwnProperty(key)) {
				i++;
			}
		}

		if (i > 1)
			return;
		trackCallEvent('CrCallDir');
	}

	/**
	 * Wrapper for trackCallEvent
	 */
	function trackCallBack(){
		trackCallEvent('CrCallBac');
	}

	/**
	 * Wrapper for trackCallEvent
	 */
	function trackCallBackSubmit(){
		trackCallEvent('CrCallBacSub');
	}
	/**
	 * Tracks a click on call direct or call back.
	 */
	function trackCallEvent(type) {
		var product = meerkat.modules.moreInfo.getOpenProduct();

		meerkat.modules.partnerTransfer.trackHandoverEvent({
			product:				product,
			type:					type,
			quoteReferenceNumber:	product.leadNo,
			productID:				product.productId,
			productName:			product.headline.name,
			productBrandCode:		product.brandCode
		}, false, false);
	}

	/**
	 * Track when we open a bridging page.
	 */
	function trackProductView(){
		meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
			method:	'trackQuoteForms',
			object:	_.bind(meerkat.modules.car.getTrackingFieldsObject, this, true)
		});
	}

	function requestTracking() {

		var settings = {
				additionalTrackingData : {
					productName : meerkat.modules.moreInfo.getOpenProduct().headline.name
				}
		};

		meerkat.modules.moreInfo.updateSettings(settings);

		trackProductView();
	}

	/**
	 *  Render the scrapes onto the placeholders in the page.
	 */
	function renderScrapes(scrapeData) {

		if (typeof scrapeData != 'undefined' && typeof scrapeData.scrapes != 'undefined' && scrapeData.scrapes.length > 0) {
			$.each(scrapeData.scrapes, function (key, scrape) {
				if (scrape.html !== '') {
					$(scrape.cssSelector).html(scrape.html);
				}
			});

		}
		// Add the icons, as we only receive li's in the scrape.
		$('.contentRow li').each(function () {
			$(this).prepend('<span class="icon icon-angle-right"></span>');
		});

	}

	/**
	 * This will only run if moreInfo.applyCallback has success === true as its parameter.
	 */
	function onApplySuccess(product) {
		// open transferring dialog, if need be.
	}

	function setSpecialConditionDetail(status, content) {
		hasSpecialConditions = status;
		specialConditionContent = content;
	}

	meerkat.modules.register("carMoreInfo", {
		initMoreInfo: initMoreInfo,
		events: events,
		setSpecialConditionDetail: setSpecialConditionDetail,
		runDisplayMethod: runDisplayMethod,
		setScrollPosition: setScrollPosition
	});

})(jQuery);