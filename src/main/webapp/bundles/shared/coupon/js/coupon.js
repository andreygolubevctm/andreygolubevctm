;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info,
		debug = meerkat.logging.debug,
		exception = meerkat.logging.exception;

	var events = {
		coupon: {
			COUPON_LOADED : "COUPON_LOADED",
            PADDING_TOP_CHANGED : "PADDING_TOP_CHANGED"
		}
	};

	var $couponIdField,
        $couponViewedField,
		$couponCodeField,
		$couponOptinField,
		$couponOptinGroup,
		$couponErrorContainer,
		$couponSuccessContainer,
		currentCoupon = false,
		hasAutoPoped = false,
		isAvailable = false,
        isPreload = false,
		isCouponValidAndSubmitted = false,
        subscriptionHandles = {},
		defaultResultsDockedTop = 147, // Hard coded in: health_v4\less\results\resultsHeaderBar.less applied to ".result"
		forceFilter = true; // Set to true to allow filter on coupons email campaigns

	function init() {

		$(document).ready(function() {

			isAvailable = checkCouponsAvailability();

			if (isAvailable === true) {
				$couponIdField = $('.coupon-id-field'),
				$couponCodeField = $('.coupon-code-field'),
				$couponViewedField = $('.coupon-viewed-field'),
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

		// If we are already in small screen keep an eye out for a window resize.
		if (meerkat.modules.deviceMediaState.get() === 'xs') {
			meerkat.messaging.subscribe(meerkatEvents.device.RESIZE_DEBOUNCED, function resultsXsBreakpointEnter() {
				dealWithAddedCouponHeight();
			});
		}

		meerkat.messaging.subscribe(meerkatEvents.device.STATE_ENTER_XS, function resultsXsBreakpointEnter() {
			// The banner can still change in height so we need to watch the window resize and react accordingly.
			meerkat.messaging.subscribe(meerkatEvents.device.RESIZE_DEBOUNCED, function resultsXsBreakpointEnter() {
				dealWithAddedCouponHeight();
			});
		});

		meerkat.messaging.subscribe(meerkatEvents.device.STATE_LEAVE_XS, function resultsXsBreakpointLeave() {
			meerkat.messaging.unsubscribe(meerkatEvents.device.RESIZE_DEBOUNCED);
			dealWithAddedCouponHeight();
		});

		$(document).on('headerAffixed', function() {
			dealWithAddedCouponHeight();
		});
		$(document).on('headerUnaffixed', function() {
			dealWithAddedCouponHeight();
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
		if (isAvailable !== true && meerkat.site.isCallCentreUser !== true) return;
		if (!type) return;

		var url = '',
			data = {};

		data.transactionId = meerkat.modules.transactionId.get();

		switch(type) {
			case "couponId":
				url = 'coupon/id/get.json';
				data.couponId = dataParam;
				break;
            case "simplesCouponLoad":
                url = 'coupon/id/get.json';
                data.couponId = dataParam;
                data.showCouponSeen = 1;
            	break;
			case "filter":
				if (!forceFilter) {
                    // if already have a coupon (most likely from email campaign or vdn prefill), do not filter
                    if (isCurrentCouponValid() === true && isPreload === true) {
                        if (typeof successCallBack === 'function') {
                            successCallBack();
                        }
                        return;
                    }
                }

                if (isPreload) {
					data.couponId = meerkat.site.couponId;
				}

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
			if (type !== 'simplesCouponLoad') {
				populateFields();
            }
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
		if (isCurrentCouponValid() === true && currentCoupon.hasOwnProperty('contentBanner')) {
            $('#contactForm').find('.quoteSnapshot').hide();
            $('.callCentreHelp').hide();

            meerkat.modules.bannerPlacement.render({
                content: { top: currentCoupon['contentBanner'], tile: currentCoupon['contentTile'] },
				type: 'coupon'
            });

            $('body').addClass('couponShown');

            meerkat.modules.healthMoreInfo.dynamicPyrrBanner();

		} else {
            $('#contactForm').find('.quoteSnapshot').show();
            $('.callCentreHelp').show();
            $('#contactForm').find('.callCentreHelp').hide();
            $('.coupon-banner-container, .coupon-tile-container').html('');
            $('body').removeClass('couponShown');

            meerkat.modules.bannerPlacement.unRender({
				type: 'coupon'
			});
        }

		dealWithAddedCouponHeight();

	}

	function dealWithAddedCouponHeight() {
		// If we have a visible coupon.
		var $bodyWithCoupon = $('body.couponShown');
		// Reset everything in case we have changed between results and other slides or changed view port.
		resetMeasurements();

		// We need to accommodate the journey with additional space when we have coupon on mobile.
		if ($bodyWithCoupon.length > 0 && meerkat.modules.deviceMediaState.get() === 'xs') {
			// Get the header.
			var $headerWrap = $('.header-wrap');

			// Results is handled differently.
			if (meerkat.modules.journeyEngine.getCurrentStep().navigationId === 'results') {
				// Get the coupon banners height and add it to the current padding.
				var bannersHeight = $('.coupon-banner-container').innerHeight();
				// The actual padding top is set in the less using various less calculations.
				// Since it could be be a different hight we need to get the current value the add to it.
				var bodyPaddingTop = typeof $bodyWithCoupon.css('padding-top') !== 'undefined' ? parseInt($bodyWithCoupon.css('padding-top').replace(/\D/g,'')): 0;
				var newPaddingTop = bodyPaddingTop + bannersHeight;

				// Clear the min height and apply the padding top to the body
				$headerWrap.css({'min-height': ''});

                $bodyWithCoupon.css({'padding-top': newPaddingTop + 'px'});
                meerkat.messaging.publish(events.coupon.PADDING_TOP_CHANGED);

				// Get the results affixed
				var $dockedResultsHeaders = $('.affixed-settings .result');

				$.each($dockedResultsHeaders, function() {
					var $dockedResultsHeader = $(this);
					topValueToBeApplied = defaultResultsDockedTop + bannersHeight;
					$dockedResultsHeader.css({'top': topValueToBeApplied + 'px'});
				});

			} else {
				// Get the inner divs combined height
				var headersActualHeight = $headerWrap.children().innerHeight();
				// Now that's the real min height
				$headerWrap.css({'min-height': headersActualHeight + 'px'});

			}
		}
	}

	// We need to reset the values back to default, since modifying these with jQuery will apply a
	// style directly to the DOM, we can just remove that style attribute to reset it.
	function resetMeasurements() {
		var $headerWrap = $('.header-wrap');
		var $bodyWithCoupon = $('body.couponShown');
		var $dockedResultsHeaders = $('.result');
		$headerWrap.removeAttr('style');
		$bodyWithCoupon.removeAttr('style');
		$dockedResultsHeaders.removeAttr('style');

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
	 * Validation logic when user submit the coupon
	 * It is not using the jounery jQuery validation as we still want the user to be able to progress the journey with failed validation
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
            $couponViewedField.val(currentCoupon.couponId);
		} else {
            if ($couponIdField) {
                $couponIdField.val('');
            }
            if ($couponCodeField) {
                $couponCodeField.val('');
            }
        }
	}

    function triggerPopup() {
        // make sure we only subscribe one time
        if (hasAutoPoped === false) {
            if (isCurrentCouponValid() === true) {
                if (currentCoupon.showPopup === true) {
                    $('.coupon-tile:first').trigger('click');
                    hasAutoPoped = true;
                }
            } else if (!subscriptionHandles['firstTimeAutoPopup']) {
                // if no coupon available, waite for the event
                subscriptionHandles['firstTimeAutoPopup'] = meerkat.messaging.subscribe(events.coupon.COUPON_LOADED, function autoPopupCoupon() {
                    _.defer(function(){
                        if (hasAutoPoped === false && isCurrentCouponValid() === true && currentCoupon.showPopup === true) {
                            $('.coupon-tile:first').trigger('click');
                            hasAutoPoped = true;
                        }
                    });
                });
            }
        }
    }

	function getCurrentCoupon() {
		return currentCoupon;
	}

	function setCurrentCoupon(coupon) {
		currentCoupon = coupon;
	}

	function getCouponViewedId() {
        $couponViewedField = $couponViewedField || $('.coupon-viewed-field');
        return $couponViewedField.length === 1 && $couponViewedField.val() !== '' ? $couponViewedField.val() : null;
	}

	meerkat.modules.register("coupon", {
		init: init,
		events: events,
		loadCoupon: loadCoupon,
		getCurrentCoupon: getCurrentCoupon,
		validateCouponCode: validateCouponCode,
		renderCouponBanner: renderCouponBanner,
        triggerPopup: triggerPopup,
        dealWithAddedCouponHeight: dealWithAddedCouponHeight,
        getCouponViewedId: getCouponViewedId
	});

})(jQuery);