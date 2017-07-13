(function ($, undefined) {

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events;

	var events = {
			homeMoreInfo: {
				// home specific events
			}
		},
		moduleEvents = events.homeMoreInfo;

	var $bridgingContainer = $('.bridgingContainer'),
		callDirectLeadFeedSent = {},
		specialConditionContent = '', // content for the special condition dialog
		hasSpecialConditions = false, // to display the special condition dialog
		callbackModalId, // the id of the currently displayed callback modal
		scrapeType, //The type of scrape 'home', 'contents' or 'homeandcontents'
		scrollPosition, //The position of the page on the modal display,
		callDirectTrackingFlag = true; // used to flag when ok to call tracking on CallDirect (once per transaction)

	/**
	 * Specify the options within here to pass to meerkat.modules.moreInfo.
	 */
	function initMoreInfo() {

		var options = {
			container: $bridgingContainer,
			hideAction: 'fadeOut',
			showAction: 'fadeIn',
			showActionWhenOpen: 'fadeIn',
			modalOptions: {
				className: 'modal-breakpoint-wide modal-tight bridgingContainer',
				openOnHashChange: false,
				leftBtn: {
					label: 'All Products',
					icon: '<span class="icon icon-arrow-left"></span>',
					callback: function (eventObject) {
						$(eventObject.currentTarget).closest('.modal').modal('hide');
					}
				},
				rightBtn: {
					label: 'SAVE QUOTE',
					className: 'btn-sm btn-save',
					callback: meerkat.modules.saveQuote.openAsModal
				}
			},
			runDisplayMethod: runDisplayMethod,
			onBeforeShowBridgingPage: onBeforeShowBridgingPage,
			onBeforeShowTemplate: renderScrapes,
			onBeforeShowModal: renderScrapes,
			onAfterShowModal: null,
			onAfterShowTemplate: onAfterShowTemplate,
			onBeforeHideTemplate: null,
			onAfterHideTemplate: onAfterHideTemplate,
			onClickApplyNow: onClickApplyNow,
			onBeforeApply: null,
			onApplySuccess: onApplySuccess,
			retrieveExternalCopy: retrieveExternalCopy,
			additionalTrackingData: {
				verticalFilter: null,
				productName: null
			}
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
			modalCallActions(event, $el);

		}).on('click', '.btn-submit-callback', function (event) {
			var $el = $(this);
			submitCallback(event, $el);
		});
	}

	/**
	 * Setup the form fields/values for the callback form.
	 * Also bind validation rules.
	 */
	function setupCallbackForm() {
		meerkat.modules.jqueryValidate.setupDefaultValidationOnForm( $('#getcallback') );

		// populate client name if empty
		var $clientName = $("#home_CrClientName");
		var $firstName = $("#home_policyHolder_firstName");
		var $lastName = $("#home_policyHolder_lastName");
		var test1 = $firstName.length;
		var test2 = $lastName.length;
		if( ($firstName.length && $firstName.val() !== '') || ($lastName.length && $lastName.val() !== '') ) {
			$clientName.val($.trim($firstName.val() + " " + $lastName.val()));
		}

		// populate client number if empty
		var $telNum = $("#home_CrClientTelinput");
		if ($telNum.length && !$telNum.val().length) {
			$telNum.val($('#home_policyHolder_phone').val()).blur();
		}
		$telNum.attr('data-msg-required', "Please enter your contact number");
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
	function recordCallDirect(event, product) {

		// Call supertag to register event - only once per transaction
		trackCallDirect(product);// Add CallDirect request event to supertag

		var currProduct = product;
		if (typeof callDirectLeadFeedSent[currProduct.productId] != 'undefined')
			return;

		var currentBrandCode = meerkat.site.tracking.brandCode.toUpperCase();

		return callLeadFeedSave(event, {
			message: currentBrandCode+' - Home Vertical - Call direct',
			phonecallme: 'CallDirect'
		}, product);
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

		var state = $("#home_property_address_state").val();
		var currentBrandCode = meerkat.site.tracking.brandCode.toUpperCase();
		var clientName = '';
		var clientTel = '';
		var $CrClientName = $("#home_CrClientName");
		var CrClientName = $CrClientName.length ? $CrClientName.val() : "";
		var firstName = $("#home_policyHolder_firstName").val();
		var lastName = $("#home_policyHolder_lastName").val();
		var $CrClientTel = $("#home_CrClientTel");
		var CrClientTel = $CrClientTel.length ? $CrClientTel.val() : "";
		var policyHolderPhone = $("#home_policyHolder_phone").val();

		if(CrClientName !== ""){
			clientName = CrClientName;
		} else if(firstName !== '' || lastName !== '' ) {
			clientName = $.trim(firstName + " " + lastName);
		}

		if(CrClientTel !== ''){
			clientTel = CrClientTel;
		} else if(policyHolderPhone !== '' ) {
			clientTel = policyHolderPhone;
		}

		var quoteNumber = product.quoteNumber;


		var defaultData = {
			state:				state,
			brand:				product.productId.split('-')[0],
			productId:			product.productId,
			clientNumber:		quoteNumber,
			clientName:			clientName,
			phoneNumber:		clientTel,
			partnerReference:	meerkat.modules.transactionId.get()
		};

		var allData = $.extend(defaultData, data);

		var $element = $(event.target);
		meerkat.modules.loadingAnimation.showInside($element, true);
		return meerkat.modules.comms.post({
			url: "leadfeed/homecontents/getacall.json",
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
						onClose: function (modalId) {
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
	function updateQuoteSummaryTable() {
		var $table = $('.quote-summary-table');

		$table.find('tbody tr').remove();

		var rowHTML = '';

		var addRow = function(coverType, coverAmount, extraCopy) {
			// convert value to comma separated digits
			coverAmount = coverAmount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
			
			var tempHTML = [
				'<tr>',
				'<td>',
				coverType,
				'</td>',
				'<td class="cover-amount">',
				'$<span>',
				coverAmount,
				extraCopy,
				'</span>',
				'</td>',
				'</tr>'
			].join('');

			rowHTML += tempHTML;
		};

		// Add Home / Contents / Home & Contents to table
		var coverType = meerkat.modules.home.getCoverType();

		if(coverType == "H" || coverType == "HC") {
			var rebuildCost = parseInt($('#home_coverAmounts_rebuildCost').val());
			if (meerkat.site.isLandlord) {
				addRow('Building Cover', rebuildCost);
			} else {
				addRow('Home Cover', rebuildCost);
			}
			
		}
		
		if(coverType == "C" || coverType == "HC") {
			var contentsCost = parseInt(meerkat.site.isLandlord ? $('#home_coverAmounts_replaceContentsCostLandlord').val() : $('#home_coverAmounts_replaceContentsCost').val());
			
			var selectedProduct = Results.getSelectedProduct();
			if(!_.isEmpty(selectedProduct) && parseInt(selectedProduct.contentsExcess.insuredValue) !== contentsCost) {
				contentsCost = selectedProduct.contentsExcess.insuredValue;
				addRow('Contents Cover', contentsCost, "&nbsp;<br class='visible-md'><em>(minimum insurable value for this provider)</em>");
			} else {
				addRow('Contents Cover', contentsCost, "");
			}

			// Add Personal Effects to table if specified in form
			if($('.itemsAway :checked').val() == "Y") {
				var totalPersonalEffects = parseInt($('#home_coverAmounts_unspecifiedCoverAmount').val());

				if($('.specifyPersonalEffects :checked').val() == "Y") {
					$('.specifiedItems input[type="hidden"]').each(function() {
						var itemValue = this.value || 0;
						totalPersonalEffects += parseInt(itemValue);
					});
				}

				addRow("Personal Effects", totalPersonalEffects);
			}
		}

		$table.append(rowHTML);
	}
	function eventSubscriptions() {

		meerkat.messaging.subscribe(meerkatEvents.ADDRESS_CHANGE, function bridgingPageHashChange(event) {
			if (meerkat.modules.deviceMediaState.get() != 'xs' && event.hash.indexOf('/moreinfo') == -1) {
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

		meerkat.messaging.subscribe(meerkatEvents.homeResults.FEATURES_CALL_ACTION, function triggerCallActions(obj) {
			callActions(obj.event, obj.element);
		});

		meerkat.messaging.subscribe(meerkatEvents.homeResults.FEATURES_CALL_ACTION_MODAL, function triggerCallActionsFromModal(obj) {
			modalCallActions(obj.event, obj.element);
		});

		meerkat.messaging.subscribe(meerkatEvents.homeResults.FEATURES_SUBMIT_CALLBACK, function triggerSubmitCallback(obj) {
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
		var obj = Results.getResultByProductId($el.attr('data-productId'));

		// If its unavailable, don't do anything
		// This is if someone tries to fake a bridging page for a "non quote" product.
		if (obj.available != 'Y')
			return;

		var $e = $('#home-call-modal-template');
		if ($e.length) {
			templateCallback = _.template($e.html());
		}

		var htmlContent = templateCallback(obj);
		var modalOptions = {
			htmlContent: htmlContent,
			hashId: 'call',
			className: 'call-modal ' + obj.brandCode,
			closeOnHashChange: true,
			openOnHashChange: false,
			onOpen: function (modalId) {

				$('.' + $el.attr('data-callback-toggle')).show();
				fixSidebarHeight('.paragraphedContent:visible', '.sidebar-right', $('#'+modalId));

				setupCallbackForm();

				if ($el.hasClass('btn-calldirect')) {
					recordCallDirect(event, obj);
				} else {
					trackCallBack(obj);// Add CallBack request event to supertag
				}

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

		switch ($el.attr('data-callback-toggle')) {
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
					message: currentBrandCode+' - Home Vertical - Call me now',
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
			$('.resultsContainer, #navbar-compare, #navbar-filter, #navbar-filter-labels').hide();
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
		$('.resultsContainer, #navbar-filter, #navbar-compare, #navbar-filter-labels').show();
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
		setScrapeType ();

		return meerkat.modules.comms.get({
			url: "spring/rest/home/more_info/get.json",
			cache: true,
			data: {
				productId: product.productId,
				coverType: meerkat.modules.home.getCoverType(),
				environmentOverride: $('#environmentOverride').val()
			},
			errorLevel: "silent",
			onSuccess: function (result) {
				// If a provider does not have these stored in the database, we default to the actual products response.
				result.benefits = result.benefits === '' ? product.benefits : result.benefits;
				result.inclusions = result.inclusions === '' ? product.inclusions : result.inclusions;
				result.optionalExtras = result.optionalExtras === '' ? product.optionalExtras : result.optionalExtras;
				meerkat.modules.moreInfo.setDataResult(result);
			},
			onError: function(jqXHR) {
				Results.model.ajaxRequest = false;
				var jsonResult = {};
				try {
					jsonResult = $.parseJSON(jqXHR.responseText);
				} catch (error) {}
				Results.model.ajaxRequest = false;
				if(jsonResult.type == "validation") {
					Results.model.handleValidationError({error : jsonResult});
				}
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
		if(hasSpecialConditions === true && specialConditionContent.length) {

			var $e = $('#special-conditions-template');
			if ($e.length) {
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
				errorLevel: 'warning',
				message: "An error occurred. Sorry about that!<br /><br /> To purchase this policy, please contact the provider " + (product.contact.phoneNumber !== '' ? " on " + product.contact.phoneNumber : "directly") + " quoting " + product.quoteNumber + ", or select another policy.",
				page: 'homeMoreInfo.js:proceedToInsurer',
				description: "Insurer did not provide quoteUrl in results object.",
				data: product
			});
			// stops the propagation to the links event handler.
			return false;
		}

		var leadFeedInfoArr = product.leadfeedinfo.split("||");
		var leadFeed = false;
		if(!_.isEmpty(leadFeedInfoArr[0])) { // if empty then user hasn't opted in for call
			leadFeed = {
				data: {
					vertical: 'homecontents',
					phonecallme: "NoSaleCall",
					productId: product.productId,
					clientName: leadFeedInfoArr[0],
					phoneNumber: leadFeedInfoArr[1],
					clientNumber: product.quoteNumber,
					partnerReference: meerkat.modules.transactionId.get(),
					brand: product.productId.split('-')[0],
					state: $('#home_property_address_state').val()
				},
				settings: {
					errorLevel: "silent"
				}
			};
		}

		meerkat.modules.partnerTransfer.transferToPartner({
			encodeTransferURL: true,
			product: product,
			applyNowCallback: applyNowCallback,
			productName: product.productName,
			productBrandCode: product.brandCode,
			brand: product.providerProductName,
			verticalFilter: meerkat.modules.home.getVerticalFilter(),
			productID: product.trackingProductId,
			noSaleLead: leadFeed
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
			product: product,
			type: type,
			quoteReferenceNumber: product.quoteNumber,
			transactionID: meerkat.modules.transactionId.get(),
			productID: product.productId,
			productName: product.productName,
			verticalFilter: meerkat.modules.home.getVerticalFilter(),
			productBrandCode: product.brandCode
		}, false);
	}

	/**
	 * Track when we open a bridging page.
	 */
	function trackProductView(){
		meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
			method:	'trackQuoteForms',
			object:	_.bind(meerkat.modules.home.getTrackingFieldsObject, this, true)
		});
	}

	/**
	 *  Render the scrapes onto the placeholders in the page.
	 */
	function setScrapeType () {
		var coverType = meerkat.modules.home.getCoverType();
		switch (coverType){
			case 'H':
				scrapeType = "home";
				return;
			case 'C':
				scrapeType = "contents";
				return;
			case 'HC':
				scrapeType = "homeandcontents";
				return;
		}
	}

	function requestTracking() {

		var product = meerkat.modules.moreInfo.getOpenProduct();

		var settings = {
			additionalTrackingData: {
				verticalFilter: meerkat.modules.home.getVerticalFilter(),
				productName: product.productName,
				productID: product.trackingProductId
			}
		};

		meerkat.modules.moreInfo.updateSettings(settings);

		trackProductView();
	}

	function renderScrapes(product) {

		updateQuoteSummaryTable();

		$("#inclusions").html(product.inclusions);
		$("#extras").html(product.optionalExtras);
		$("#benefits").html(product.benefits);

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

	meerkat.modules.register("homeMoreInfo", {
		initMoreInfo: initMoreInfo,
		events: events,
		setSpecialConditionDetail: setSpecialConditionDetail,
		runDisplayMethod: runDisplayMethod,
		setScrollPosition: setScrollPosition
	});

})(jQuery);