(function ($, undefined) {

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		$bridgingContainer = $('.bridgingContainer');

	var events = {
			homeloanMoreInfo: {
				// homeloan specific events
			}
		},
		moduleEvents = events.homeloanMoreInfo;
	/**
	 * Specify the options within here to pass to meerkat.modules.moreInfo.
	 */
	function initMoreInfo() {
		var options = {
			container: $bridgingContainer,
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
			onBeforeShowBridgingPage: null,
			onBeforeShowTemplate: null,
			onBeforeShowModal: onBeforeShowModal,
			onAfterShowModal: trackProductView,
			onAfterShowTemplate: null,
			onBeforeHideTemplate: null,
			onAfterHideTemplate: null,
			onClickApplyNow: onClickApplyNow,
			onBeforeApply: null,
			onApplySuccess: null,
			retrieveExternalCopy: retrieveExternalCopy,
			additionalTrackingData: {
				verticalFilter: meerkat.modules.homeloan.getVerticalFilter()
			}
		};

		meerkat.modules.moreInfo.initMoreInfo(options);

		eventSubscriptions();
		applyEventListeners();
	}

	function applyEventListeners() {
		$(document.body).on('click', '.btn-apply', onClickApplyNow);
	}

	/**
	 * Handles how you want to display the bridging page based on your viewport/requirements
	 */
	function runDisplayMethod(productId) {
		meerkat.modules.moreInfo.showModal();
		meerkat.modules.address.appendToHash('moreinfo');
	}

	function eventSubscriptions() {
		meerkat.messaging.subscribe(meerkatEvents.device.STATE_ENTER_XS, function bridgingPageEnterXsState() {
			if (meerkat.modules.moreInfo.isModalOpen()) {
				meerkat.modules.moreInfo.close();
			}
		});

		meerkat.messaging.subscribe(meerkatEvents.device.STATE_LEAVE_XS, function bridgingPageLeaveXsState() {
			if (meerkat.modules.moreInfo.isModalOpen()) {
				meerkat.modules.moreInfo.close();
			}
		});
	}

	/**
	 * Retrieves the data used for the bridging page.
	 */
	function retrieveExternalCopy(product) {
		// Not called
		return $.Deferred(function(dfd) {
			meerkat.modules.moreInfo.setDataResult(product);
			return dfd.resolveWith(this, []).promise();
		});
	}
	/**
	 * When you click the btn-apply.
	 */
	function onClickApplyNow() {
		Results.model.setSelectedProduct($('.btn-apply').attr('data-productId'));

		meerkat.modules.homeloan.trackHandover();

		meerkat.modules.journeyEngine.gotoPath("next");
	}

	function onBeforeShowModal(product) {

		var settings = {'additionalTrackingData' : {'productName': product.lenderProductName}};
		meerkat.modules.moreInfo.updateSettings(settings);
	}

	function trackProductView(){
		meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
			method:	'trackQuoteForms',
			object:	_.bind(meerkat.modules.homeloan.getTrackingFieldsObject, this, true)
		});
	}



	meerkat.modules.register("homeloanMoreInfo", {
		initMoreInfo: initMoreInfo,
		events: events,
		runDisplayMethod: runDisplayMethod
	});

})(jQuery);