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
		activeCallModal,
		callDirectTrackingFlag = true; // used to flag when ok to call tracking on CallDirect (once per transaction)

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
			},
			onBreakpointChangeCallback : _.bind(resizeSidebarOnBreakpointChange, this, '.paragraphedContent', '.moreInfoRightColumn', $bridgingContainer)
		};

		meerkat.modules.moreInfo.initMoreInfo(options);

		eventSubscriptions();
		applyEventListeners();
	}

	function applyEventListeners() {

		$(document).on('click', '.bridgingContainer .btn-call-actions', function (event) {
			var $el = $(this);
			callActions(event, $el);
		}).on('click', '.call-modal .btn-call-actions', function (event) {
			var $el = $(this);
			modalCallActions(event, $el)

		}).on('click', '.btn-submit-callback', function (event) {
			var $el = $(this)
			submitCallback(event, $el);
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

	function resizeSidebarOnBreakpointChange(leftContainer, rightContainer, mainContainer) {
		if (meerkat.modules.deviceMediaState.get() == 'lg' || meerkat.modules.deviceMediaState.get() == 'md') {
			fixSidebarHeight(leftContainer, rightContainer, mainContainer);
		}
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
				// firstly reset the height of the columns
				$(leftSelector, $container).css('min-height', '0px');
				$(rightSelector, $container).css('min-height', '0px');
				// Then measure the heights to work out which to toggle
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
	function recordCallDirect(event, product) {

		// Call supertag to register event - only once per transaction
		trackCallDirect(product);// Add CallDirect request event to supertag

		var currProduct = product;
		if (typeof callDirectLeadFeedSent[currProduct.productId] != 'undefined') {
			return;
		}

		var currentBrandCode = meerkat.site.tracking.brandCode.toUpperCase();

		return callLeadFeedSave(
			event,
			{
				message: currentBrandCode+' - Car Vertical - Call direct',
				phonecallme: 'CallDirect'
			},
			product
		);
	}
	/**
	 * Perform the lead feed save request for both call direct and call back functions.
	 * @param {event} event The event object from the button click
	 * @param {POJO} data The data to extend into the AJAX request
	 */
	function callLeadFeedSave(event, data, product) {

		if (typeof product !== 'undefined' && product !== null && typeof product.vdn !== 'undefined' && !_.isEmpty(product.vdn) && product.vdn > 0) { // VDN is a number
			data.vdn = product.vdn;
		}

		var currentBrandCode = meerkat.site.tracking.brandCode.toUpperCase();

		var defaultData = {
				state: $("#quote_riskAddress_state").val(),
				brand: product.productId.split('-')[0],
				productId: product.productId
		};

		if(meerkat.site.leadfeed[data.phonecallme].use_disc_props) {
			$.extend(defaultData, {
				source: currentBrandCode+'CAR',
				leadNo: product.leadNo,
				client: $('#quote_CrClientName').val() || '',
				clientTel: $('#quote_CrClientTelinput').val() || '',
				transactionId: meerkat.modules.transactionId.get()
			});
		} else {
			$.extend(defaultData, {
				clientNumber: product.leadNo,
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
					callDirectLeadFeedSent[product.productId] = true;
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

		meerkat.messaging.subscribe(meerkatEvents.transactionId.CHANGED, function updateCallDirectTrackingFlag() {
			callDirectTrackingFlag = true;
		});

		meerkat.messaging.subscribe(meerkatEvents.carResults.FEATURES_CALL_ACTION, function triggerCallActions(obj) {
			callActions(obj.event, obj.element);
		});

		meerkat.messaging.subscribe(meerkatEvents.carResults.FEATURES_CALL_ACTION_MODAL, function triggerCallActionsFromModal(obj) {
			modalCallActions(obj.event, obj.element);
		});

		meerkat.messaging.subscribe(meerkatEvents.carResults.FEATURES_SUBMIT_CALLBACK, function triggerSubmitCallback(obj) {
			submitCallback(obj.event, obj.element);
		});
	}

	function callActions(event, element) {
			/**
			 * Render the call modal template, set up default name values, fix height
			 */
			event.preventDefault();
			event.stopPropagation();
			var $el = element;

			var $e = $('#car-call-modal-template');
			if ($e.length > 0) {
				templateCallback = _.template($e.html());
			}
			var obj = Results.getResultByProductId($el.attr('data-productId'));

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
						recordCallDirect(event, obj);
					} else {
						trackCallBack(obj);// Add CallBack request event to supertag
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
	}

	function modalCallActions(event, element) {
		/**
		 * Just toggle between the modes here in the modal.
		 */
		if(meerkat.modules.deviceMediaState.get() != 'xs') {
			event.preventDefault();
		}
		event.stopPropagation();
		var $el = element;
		var obj = Results.getResultByProductId($el.attr('data-productId'));

		activeCallModal = $el.attr('data-callback-toggle');
		var sessionCamStep = meerkat.modules.sessionCamHelper.getMoreInfoStep(activeCallModal);

		switch (activeCallModal) {
		case 'calldirect':
			$('.callback').hide();
			$('.calldirect').show();
			recordCallDirect(event, obj);
			break;
		case 'callback':
			$('.calldirect').hide();
			$('.callback').show();
			trackCallBack(obj);// Add CallBack request event to supertag
			break;
		}

		// Fix the height of the sidebar
		fixSidebarHeight('.paragraphedContent:visible', '.sidebar-right', $el.closest('.modal.in'));

		// Update session cam virtual page
		meerkat.modules.sessionCamHelper.updateVirtualPage(sessionCamStep);
	}

	function submitCallback(event, element) {
			event.preventDefault();
			var $el = element;
			var obj = Results.getResultByProductId($el.attr('data-productId'));
			if($el.closest('form').valid()) {
				var currentBrandCode = meerkat.site.tracking.brandCode.toUpperCase();
				callLeadFeedSave(
					event,
					{
						message: currentBrandCode+' - Car Vertical - Call me now',
						phonecallme: 'GetaCall'
					},
					obj
				);

				trackCallBackSubmit(obj);// Add CallBack Submit request event to supertag
			} else {
				_.delay(function() {
					fixSidebarHeight('.paragraphedContent:visible', '.sidebar-right', $el.closest('.modal.in'));
				}, 200);
			}
			return false;
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

		var leadFeedInfoArr = product.leadfeedinfo.split("||");
		var leadFeed = false;
		if(!_.isEmpty(leadFeedInfoArr[0])) { // if empty then user hasn't opted in for call
			leadFeed = {
				data:		{
					vertical:			meerkat.site.vertical,
					phonecallme:		"NoSaleCall",
					productId:			product.productId,
					clientName:			leadFeedInfoArr[0],
					phoneNumber:		leadFeedInfoArr[1],
					clientNumber:		product.leadNo,
					partnerReference:	meerkat.modules.transactionId.get(),
					brand:				product.productId.split('-')[0],
					state:				$('#quote_riskAddress_state').val()
				},
				settings:	{
					errorLevel:	"silent"
				}
			};
		}

		meerkat.modules.partnerTransfer.transferToPartner({
			encodeTransferURL:	true,
			product:			product,
			applyNowCallback:	applyNowCallback,
			productName:		product.headline.name,
			productBrandCode:	product.brandCode,
			brand:				product.productDes,
			noSaleLead:			leadFeed
		});

		return true;
	}
	/**
	 * Performs the supertag trackBridgingClick tracking for the CrCallDir 'type'.
	 * Will only be sent to superTag once per session.
	 * As discussed with Elvin & Tim, we won't change supertag stats, but its ok
	 * to send multiple transaction detail saves.
	 */
	function trackCallDirect(product){
		if(callDirectTrackingFlag === true) {
			callDirectTrackingFlag = false;
			trackCallEvent('CrCallDir', product);
		} else {
			return;
		}
	}

	/**
	 * Wrapper for trackCallEvent
	 */
	function trackCallBack(product){
		trackCallEvent('CrCallBac', product);
	}

	/**
	 * Wrapper for trackCallEvent
	 */
	function trackCallBackSubmit(product){
		trackCallEvent('CrCallBacSub', product);
	}
	/**
	 * Tracks a click on call direct or call back.
	 */
	function trackCallEvent(type, product) {
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