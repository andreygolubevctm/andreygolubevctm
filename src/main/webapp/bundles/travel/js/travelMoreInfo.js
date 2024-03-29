(function ($, undefined) {

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		$bridgingContainer = $('.bridgingContainer');

	var events = {
			travelMoreInfo: {
				// travel specific events
			}
		},
		moduleEvents = events.travelMoreInfo,
		initialised = false;
	/**
	 * Specify the options within here to pass to meerkat.modules.moreInfo.
	 */
	function initMoreInfo() {
		if(!initialised) {
			initialised = true;

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
				retrieveExternalCopy: retrieveExternalCopy
			};

			meerkat.modules.moreInfo.initMoreInfo(options);

			eventSubscriptions();
			applyEventListeners();
		}
	}

	function applyEventListeners() {
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

	function onBeforeShowModal(product) {

		var settings = {'additionalTrackingData' : {
			'productBrandCode': product.provider,
			'productName': product.name,
			'verticalFilter': meerkat.modules.travel.getVerticalFilter()
			}
		};
		meerkat.modules.moreInfo.updateSettings(settings);
	}

	/**
	 * Retrieves the data used for the bridging page.
	 */
	function retrieveExternalCopy(product) {

		return $.Deferred(function(dfd) {

			// assign the sort results to a new 'sorting' object
			product.sorting = _.sortBy(product.benefits, 'desc');

			meerkat.modules.moreInfo.setDataResult(product);
			return dfd.resolveWith(this, [product]).promise();
		});
	}

	// creates an array of benefits contained within the exemptedBenefits node (if it exists)
	function benefitException(product)
	{
		var exemptedBenefits = [];
		if (typeof product.exemptedBenefits !== 'undefined')
		{
			$.each(product.exemptedBenefits, function(a){
				exemptedBenefits.push(product.exemptedBenefits[a]);
			});
		}
		return exemptedBenefits;
	}

	/**
	 * When you click the btn-more-info-apply.
	 * Pre-dispatch checking and functionality.
	 * @param {POJO} product The selected product
	 */
	function onClickApplyNow(product, applyNowCallback) {
		var options = {
				product: product,
				applyNowCallback: applyNowCallback
			};

		meerkat.modules.partnerTransfer.transferToPartner(options);
	}

	function trackProductView(){
		meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
			method:	'trackQuoteForms',
			object:	_.bind(meerkat.modules.travel.getTrackingFieldsObject, this, true)
		});
	}



	meerkat.modules.register("travelMoreInfo", {
		initMoreInfo: initMoreInfo,
		events: events,
		runDisplayMethod: runDisplayMethod
	});

})(jQuery);