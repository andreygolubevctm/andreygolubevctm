;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info,
		debug = meerkat.logging.debug,
		exception = meerkat.logging.exception;

	var events = {
		coupon: {
			COUPON_LOADED : "COUPON_LOADED"
		}
	};

	var $couponIdField,
		$couponCodeField,
		$couponOptinField,
		$couponOptinGroup,
		$couponErrorContainer,
		$couponSuccessContainer,
		currentCoupon = false,
		hasAutoPoped = false,
		isAvailable = false,
        isPreload = false,
		isCouponValidAndSubmitted = false;

	function init() {

		$(document).ready(function() {

			isAvailable = checkCouponsAvailability();

			if (isAvailable === true) {
				$couponIdField = $('.coupon-id-field'),
				$couponCodeField = $('.coupon-code-field'),
				$couponOptinField = $('.coupon-optin-field').find('input'),
				$couponOptinGroup = $('.coupon-optin-group'),
				$couponErrorContainer = $('.coupon-error-container'),
				$couponSuccessContainer = $('.coupon-success-container');

				preload();

				_.defer(function() {
					eventSubscriptions();
				});
			}
		});
	}

	function eventSubscriptions() {
		meerkat.messaging.subscribe(meerkatEvents.journeyEngine.STEP_CHANGED, function() {
			resetWhenChangeStep();
		});
	}

	function checkCouponsAvailability() {
		return $('.coupon-id-field').length > 0;
	}

	function preload() {
        if (meerkat.site.couponId !== '' ) {
            isPreload = true;
			loadCoupon('couponId', meerkat.site.couponId);
		} else {
            isPreload = false;
        }
	}

	function loadCoupon(type, dataParam, successCallBack) {
		if (isAvailable !== true) return;
		if (!type) return;

		var url = '',
			data = {};

		data.transactionId = meerkat.modules.transactionId.get();

		switch(type) {
			case "couponId":
				url = 'coupon/id/get.json';
				data.couponId = dataParam;
				break;
			case "filter":
				// if already have a coupon (most likely from email campaign or vdn prefill), do not filter
				if (isCurrentCouponValid() === true && isPreload === true) {
					if (typeof successCallBack === 'function') {
						successCallBack();
					}
					return;
				}
                isPreload = false;
				url = 'coupon/filter.json';
				break;
			default:
				exception('invalid type to load coupon');
				return;
		}

		meerkat.modules.comms.get({
			url: url,
			cache: false,
			errorLevel: 'silent',
			dataType: 'json',
			data: data
		})
		.done(function onSuccess(json) {
			setCurrentCoupon(json);
			populateFields();
			meerkat.messaging.publish(events.coupon.COUPON_LOADED);
			if (typeof successCallBack === 'function') {
				successCallBack();
			}
		})
		.fail(function onError(obj, txt, errorThrown) {
			exception(txt + ': ' + errorThrown);
		});
	}


	function validateCouponCode(couponCode) {
		if (isAvailable !== true) return;
		
		var transactionId = meerkat.modules.transactionId.get();

		meerkat.modules.comms.get({
			url: 'coupon/code/validate.json',
			cache: false,
			errorLevel: 'silent',
			dataType: 'json',
			useDefaultErrorHandling: false,
			data: {
				transactionId: transactionId,
				couponCode: couponCode
			}
		})
		.done(function onSuccess(json) {
			setCurrentCoupon(json);
			validateField();
		})
		.fail(function onError(obj, txt, errorThrown) {
			exception(txt + ': ' + errorThrown);
		});
	}

	function renderCouponBanner() {
		if (isCurrentCouponValid() === true && currentCoupon.hasOwnProperty('contentTile')) {
            $('#contactForm').find('.quoteSnapshot').hide();
            $('.callCentreHelp').hide();
			$('.coupon-banner-container').html(currentCoupon.contentBanner);
            $('.coupon-tile-container').html(currentCoupon.contentTile);
			if (currentCoupon.showPopup === true && hasAutoPoped === false) {
				_.defer(function(){
					$('.coupon-tile').click();
					hasAutoPoped = true;
				});
			}
            $('body').addClass('couponShown');
		} else {
            $('#contactForm').find('.quoteSnapshot').show();
            $('.callCentreHelp').show();
            $('#contactForm').find('.callCentreHelp').hide();
            $('.coupon-banner-container, .coupon-tile-container').html('');
            $('body').removeClass('couponShown');
        }
	}

	function isCurrentCouponValid() {
		if (currentCoupon === false || !currentCoupon.hasOwnProperty('couponId')) {
			debug("Coupon has not been stored correctly - can not render");
			return false;
		}

		if (isNaN(currentCoupon.couponId) || currentCoupon.couponId <= 0) {
			debug("No valid coupon found - can not render");
			return false;
		}

		return true;
	}

	/*
	 * Vlidation logic when user submit the coupon
	 * It is not using the jounery jQuery validation as we still want the user to be able to progress the jounery with failed validation
	 */
	function validateField() {

		// empty field, reset all
		if ($.trim($couponCodeField.val()) === '') {
			$couponCodeField.parent().removeClass('has-custom-error');
			$couponErrorContainer.addClass('hidden');
			resetWhenError();
		}
		// invalid coupon or no coupon found
		else if (isCurrentCouponValid() === false) {
			$couponCodeField.parent().addClass('has-custom-error');
			$couponErrorContainer.find('label').html('Oops! This offer has now expired or you have entered an invalid code. To continue, simply remove the promo code or try re-entering your code.');
			$couponErrorContainer.removeClass('hidden');
			resetWhenError();
		}
		// hard rule validation fail
		else if (currentCoupon.hasOwnProperty('errors') && currentCoupon.errors.length > 0) {
			$couponCodeField.parent().addClass('has-custom-error');
			$couponErrorContainer.find('label').html(currentCoupon.errors[0].message).end().removeClass('hidden');
			resetWhenError();
		}
		// valid coupon
		else {
			//reset before show
			resetWhenError();

			$couponIdField.val(currentCoupon.couponId);
			$couponCodeField.parent().removeClass('has-custom-error');
			$couponErrorContainer.addClass('hidden');

			if (currentCoupon.hasOwnProperty('contentSuccess') && currentCoupon.contentSuccess !== '') {
				$couponSuccessContainer.html(currentCoupon.contentSuccess).removeClass('hidden');
			}

			if (currentCoupon.hasOwnProperty('contentCheckbox') && currentCoupon.contentCheckbox !== '') {
				$couponOptinGroup.find('.checkbox label').html(currentCoupon.contentCheckbox).end().removeClass('hidden');
			}
			else{
				// if no checkbox required, still insert optin=Y in DB so we know it is a confirmed coupon
				$couponOptinField.prop('type', 'hidden');
			}

			isCouponValidAndSubmitted = true;
		}
	}

	function resetWhenError() {
		$couponSuccessContainer.addClass('hidden');
		$couponIdField.val('');
		$couponOptinField.prop('type', 'checkbox');
		$couponOptinField.attr('checked', false);
		$couponOptinGroup.addClass('hidden');
		isCouponValidAndSubmitted = false;
	}

	function resetWhenChangeStep() {
		// do not reset if coupon has been validated and submitted
		if (isCouponValidAndSubmitted === true) return;
		$couponCodeField.parent().removeClass('has-custom-error');
		$couponSuccessContainer.addClass('hidden');
		$couponErrorContainer.addClass('hidden');
		$couponOptinField.prop('type', 'checkbox');
		$couponOptinField.attr('checked', false);
		$couponOptinGroup.addClass('hidden');
	}

	function populateFields() {
		if (isCurrentCouponValid() === true && currentCoupon.canPrePopulate === true) {
			$couponIdField.val(currentCoupon.couponId);
			$couponCodeField.val(currentCoupon.couponCode);
		} else {
            $couponIdField.val('');
            $couponCodeField.val('');
        }
	}

	function getCurrentCoupon() {
		return currentCoupon;
	}

	function setCurrentCoupon(coupon) {
		currentCoupon = coupon;
	}

	meerkat.modules.register("coupon", {
		init: init,
		events: events,
		loadCoupon: loadCoupon,
		getCurrentCoupon: getCurrentCoupon,
		validateCouponCode: validateCouponCode,
		renderCouponBanner: renderCouponBanner
	});

})(jQuery);