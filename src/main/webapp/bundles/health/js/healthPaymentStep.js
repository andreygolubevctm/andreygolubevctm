;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events;

	var moduleEvents = {
		WEBAPP_LOCK: 'WEBAPP_LOCK',
		WEBAPP_UNLOCK: 'WEBAPP_UNLOCK'
	};

	var modalId;
	var $paymentRadioGroup;
	var $paymentContainer;
	var $paymentMethodLHCText;
	var $bankSection;
	var $creditCardSection;
	var $paymentCalendar;
	var $pricePromiseMentioned;
	var $pricePromisePromotionRow;
	var $frequencySelect;
	var $bankAccountDetailsRadioGroup;
	var $sameBankAccountRadioGroup;

	var settings = {
		bank: [],
		credit: [],
		frequency: [],
		creditBankSupply: false,
		creditBankQuestions: false,
		minStartDateOffset: 0,
		maxStartDateOffset: 90,
		minStartDate: '',
		maxStartDate: ''
	};

	var currentCoupon = false,
        _startDateWeekends;

	function initHealthPaymentStep() {

		$(document).ready(function(){
			initialised = true;

			if(meerkat.site.vertical !== "health" || meerkat.site.pageAction === "confirmation") return false;

			// Fields
			initFields();

			// Add event listeners
			meerkat.messaging.subscribe(meerkatEvents.WEBAPP_LOCK, function lockPaymentStep(obj) {
				var isSameSource = (typeof obj !== 'undefined' && obj.source && obj.source === 'healthPaymentStep');
				var disableFields = (typeof obj !== 'undefined' && obj.disableFields && obj.disableFields === true);
				disableUpdatePremium(isSameSource, disableFields);
			});

			meerkat.messaging.subscribe(meerkatEvents.WEBAPP_UNLOCK, function unlockPaymentStep(obj) {
				enableUpdatePremium();
			});

			meerkat.messaging.subscribe(meerkatEvents.healthResults.SELECTED_PRODUCT_RESET, function jeStepChange(step){
				resetSettings();
			});

			$paymentCalendar.on('changeDate', function updateThePremiumOnCalendar(){
				updatePremium();
			});

			$('#health_payment_details-selection .dateinput-tripleField input').on('change', function updateThePremiumOnInput(){
				updatePremium();
			});

			var validateCoupon = function() {
				var couponInput = $('.coupon-code-field').val();
				if(currentCoupon === false || currentCoupon !== couponInput) {
					currentCoupon = couponInput;
					meerkat.modules.coupon.validateCouponCode(currentCoupon);
				}
			};

			$paymentRadioGroup.find('input').on('click', function() {
				// Delay to avoid issue when fast clicking between payment options
				_.defer(function(){
					togglePaymentGroups();
					toggleClaimsBankAccountQuestion();
					// validate coupon
					validateCoupon();
					_.defer(function delayPaymentUpdate(){
						updatePaymentPremium();
						updatePaymentDayOptions();
					});
				});
			});

			$('#health_coupon_code').blur(validateCoupon);

			$frequencySelect.on('change', function updateSidebarQuote(){
				updateProductFrequency();
				updatePaymentDayOptions();
			});

			meerkat.modules.healthCreditCard.setCreditCardRules();

			// show pay claims into bank account question (and supporting section).
			$bankAccountDetailsRadioGroup.find("input").on('click', toggleClaimsBankAccountQuestion);

			// show pay claims into bank account question (and supporting section).
			$sameBankAccountRadioGroup.find("input").on('click', toggleClaimsBankAccountQuestion);

			// Moved from fields:card_expiry.tag as part of CTMIT-555
			$("select[id$='_cardExpiryMonth']").on('change', function () {
				var $year = $("select[id$='_cardExpiryYear']");
				if ($year.hasClass('has-error') || $year.hasClass('has-success')) {
					$year.valid();
				}
			});
			// Moved from field_new:bsb_number
			$(".bsb_number").on("focus blur", function(){
				var $self = $(this), id = $self.attr('id'),
					hiddenInput = id.substring(0,id.length - 5);
				$("#"+hiddenInput).val( String($self.val()).replace(/[^0-9]/g, '') );
			}).each(function() {
				// blur both on load.
				$(this).blur();
			});

			resetSettings();

            $pricePromiseMentioned.on('change', function() {
            	var pricePromiseMentioned = $pricePromiseMentioned.is(':checked');

                if (pricePromiseMentioned) {
                    $pricePromisePromotionRow.slideDown();
				} else {
                    $pricePromisePromotionRow.slideUp();
				}

                meerkat.modules.simplesBindings.togglePricePromisePromoDialogue(pricePromiseMentioned);
			});

			// Set Dom state
			$paymentContainer.hide();

		});
	}

	function initFields() {
		$paymentRadioGroup = $("#health_payment_details_type");
		$frequencySelect = $("#health_payment_details_frequency");
		$bankAccountDetailsRadioGroup = $("#health_payment_details_claims");
		$sameBankAccountRadioGroup = $("#health_payment_bank_claims");
		$paymentMethodLHCText = $('.changes-premium .lhcText');
		$bankSection = $('.health_payment_bank-selection');
		$creditCardSection = $('.health_payment_credit-selection');
		$paymentCalendar = $('#health_payment_details_start');
		$pricePromiseMentioned = $('#health_price_promise_mentioned');
        $pricePromisePromotionRow = $('.healthPricePromisePromotionRow');

		// Containers
		$paymentContainer = $(".update-content");
	}

	// Need this function because healthGeneralFunctions destroys the event bindings via renderFields() whereas the old version only updates the dropdown
	function rebindCreditCardRules() {
        $('.health-credit_card_details-type input').on('change', meerkat.modules.healthCreditCard.setCreditCardRules);
	}

	// Settings should be reset when the selected product changes.
	function resetSettings(){

		settings.bank = { 'weekly':false, 'fortnightly': true, 'monthly': true, 'quarterly':false, 'halfyearly':false, 'annually':true };
		settings.credit = { 'weekly':false, 'fortnightly': false, 'monthly': true, 'quarterly':false, 'halfyearly':false, 'annually':true };
		settings.frequency = { 'weekly':27, 'fortnightly':31, 'monthly':27, 'quarterly':27, 'halfyearly':27, 'annually':27 };
		settings.creditBankSupply = false;
		settings.creditBankQuestions = false;

		meerkat.modules.healthCreditCard.resetConfig();

		// Clear start date

		$paymentCalendar.val('');

		// Clear payment method selection
        if (!$('.agg_privacy').hasClass('has-field-values-cc') && !$('.agg_privacy').hasClass('has-field-values-ba')) {
            $paymentRadioGroup.find('input').prop('checked', false).change();
            $paymentRadioGroup.find('label').removeClass('active');
        }

		// Clear frequency selection
		$frequencySelect.val('');

		// Clear bank account details selection
        if (!$('.agg_privacy').hasClass('has-field-values-cc') && !$('.agg_privacy').hasClass('has-field-values-ba')) {
            $("#health_payment_details_claims input").prop('checked', false).change().find('label').removeClass('active');
        }

		setCoverStartRange(0, 90);

	}

	//paymentSelectsHandler.bank => meerkat.modules.healthPaymentStep.overrideSettings('bank', xxx);
	//paymentSelectsHandler.credit => meerkat.modules.healthPaymentStep.overrideSettings('credit', xxx);
	//paymentSelectsHandler.frequency => meerkat.modules.healthPaymentStep.overrideSettings('frequency', xxx);
	//paymentSelectsHandler.creditBankSupply => meerkat.modules.healthPaymentStep.overrideSettings('creditBankSupply', xxx);
	//paymentSelectsHandler.creditBankQuestions => meerkat.modules.healthPaymentStep.overrideSettings('creditBankQuestions', xxx);
	function overrideSettings(property, value){
		settings[property] = value;
	}

	function getSetting(property){
		return settings[property];
	}

	function getSelectedPaymentMethod(){
		return $paymentRadioGroup.find('input:checked').val();
	}

	function getSelectedFrequency(){
		return (!_.isEmpty($frequencySelect.val()) ? $frequencySelect.val() : Results.getFrequency());
	}

	function setCoverStartRange(min, max){
		var applicationDate = $('#health_searchDate').val();
		var dateSplit = applicationDate ? applicationDate.split('/') : [];
		var applicationDateString = ''; 

		if(applicationDate) {
			var year = dateSplit[2];
			var month = dateSplit[1];
			var day = dateSplit[0];
			applicationDateString = year + '-' + month + '-' + day;
		}

		settings.minStartDateOffset = min;
		settings.maxStartDateOffset = max;

		// Get today's date in UTC timezone
		var today = applicationDate ? new Date(applicationDateString).getTime() : meerkat.modules.utils.getUTCToday(),
			start = 0,
			end = 0,
			hourAsMs = 60 * 60 * 1000;

		// Add 10 hours for QLD timezone
		today += (10 * hourAsMs);

		// Add the start day offset
		start = today;
		if (min > 0) {
			start += (min * 24 * hourAsMs);
		}

		// Calculate the end date
		end = today + (max * 24 * hourAsMs);
		today = new Date(start);

		var yearUtc = today.getUTCFullYear();
		var monthUtc = today.getUTCMonth()+1 < 10 ? '0' + (today.getUTCMonth()+1) : today.getUTCMonth()+1;
		var dayUtc = today.getUTCDate() < 10 ? '0' + today.getUTCDate() : today.getUTCDate();

		settings.minStartDate = dayUtc + '/' + monthUtc + '/' + yearUtc;
		today = new Date(end);
		yearUtc = today.getUTCFullYear();
		monthUtc = Number(today.getUTCMonth()+1) < 10 ? '0' + (today.getUTCMonth()+1) : today.getUTCMonth()+1;
		dayUtc = Number(today.getUTCDate()) < 10 ? '0' + today.getUTCDate() : today.getUTCDate();
		settings.maxStartDate = dayUtc + '/' + monthUtc + '/' + yearUtc;
	}

	// Show approved listings only, this can potentially change per fund
	function updateFrequencySelectOptions(){
		var product = meerkat.modules.healthResults.getSelectedProduct();

		if (!_.isEmpty(product) && !_.isEmpty(product.paymentTypePremiums)) {
            product.paymentNode = getPaymentMethodNode();
            product._selectedFrequency = getSelectedFrequency();
			var htmlTemplate = _.template($('#payment_frequency_options').html());
			var options = htmlTemplate(product);

			$frequencySelect.empty().append(options);
			updateLHCText(product);

			if (meerkat.modules.healthDualPricing.isDualPricingActive()) {
				$frequencySelect.trigger('change.healthDualPricing');
			}
		}
	}

	// Update premium button
	function enableUpdatePremium() {
		// Enable the other premium-related inputs
		// Ignore fields that were specifically disabled by funds' rules.
		var $paymentSection = $('#health_payment_details-selection');
		$paymentSection.find(':input').not('.disabled-by-fund').prop('disabled', false);
		$paymentSection.find('.select').not('.disabled-by-fund').removeClass('disabled');
		$paymentSection.find('.btn-group label').not('.disabled-by-fund').removeClass('disabled');

		// Non-inline datepicker
		//$('#health_payment_details_start').parent().addClass('input-group').find('.input-group-addon').removeClass('hidden');
		// Inline datepicker
		$paymentCalendar.parent().find('.datepicker').children().css('visibility', 'visible');
	}

	function disableUpdatePremium(isSameSource, disableFields) {

		if(disableFields === true){
			// Disable the other premium-related inputs
			var $paymentSection = $('#health_payment_details-selection');

			$paymentSection.find(':input').prop('disabled', true);
			$paymentSection.find('.select').addClass('disabled');
			$paymentSection.find('.btn-group label').addClass('disabled');

			// Non-inline datepicker
			//$('#health_payment_details_start').parent().removeClass('input-group').find('.input-group-addon').addClass('hidden');
			// Inline datepicker
			$paymentCalendar.parent().find('.datepicker').children().css('visibility', 'hidden');
		}

	}

	// Calls the server for a new premium price based on current selections.
	function updatePremium() {

		// fire the tracking call
		var data = {
			actionStep: ' health application premium update'
		};
		meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
			method:	'trackQuoteForms',
			object:	data
		});

		// Do not lock if on the results step
		if (meerkat.modules.journeyEngine.getCurrentStep().navigationId !== 'results') {
            meerkat.messaging.publish(moduleEvents.WEBAPP_LOCK, {source: 'healthPaymentStep', disableFields: true});
        }

		// Defer so we don't lock up the browser
		_.defer(function() {
			meerkat.modules.healthResults.getProductData(function(data){

				if(data === null){

					// Sometimes the date selected by the user is not actually available, show message.
					var notAvailableHtml =
						'<p>Unfortunately this policy is not currently available. Please select another policy or call our Health Insurance Specialists on <span class=\"callCentreHelpNumber\">'+meerkat.site.content.callCentreHelpNumber+'</span> for assistance.</p>' +
						'<div class="col-sm-offset-4 col-xs-12 col-sm-4">' +
						'<a class="btn btn-next btn-block" id="select-another-product" href="javascript:;">Select Another Product</a>' +
						'<a class="btn btn-cta btn-block visible-xs" href="tel:'+meerkat.site.content.callCentreHelpNumber+'">Call Us Now</a>' +
						'</div>';

					modalId = meerkat.modules.dialogs.show({
						title: 'Policy not available',
						htmlContent: notAvailableHtml
					});

					$('#select-another-product').on('click', function(){
						meerkat.modules.dialogs.close(modalId);
						meerkat.modules.journeyEngine.gotoPath('results');
					});
				}else{
					if (_.isArray(data)) data = data[0];

                    // Update selected product
					updateProductObject(data);

					// Show payment input questions
					$paymentContainer.show();

					togglePaymentGroups();

					// Show declaration checkbox
					$(".health_declaration-group").slideDown();

					toggleClaimsBankAccountQuestion();

					//re-set the days if required
					updatePaymentDayOptions();

					$("#confirm-step").show();
					$(".simples-dialogue-31").show();

					// TODO work out this: //Results._refreshSimplesTooltipContent($('#update-premium .premium'));
				}

				if (meerkat.modules.healthDualPricing.isDualPricingActive()) {
					meerkat.modules.healthDualPricing.renderTemplate('.policySummary.dualPricing', data, false, true);
				}

				meerkat.messaging.publish(moduleEvents.WEBAPP_UNLOCK, { source: 'healthPaymentStep' });

				setDefaultFields();
			});
		});
	}

	function togglePaymentGroups() {
		if(getSelectedPaymentMethod() === 'cc' ) {
			$bankSection.slideUp('fast', function(){
				$creditCardSection.slideDown('fast');
			});
		} else {
			$creditCardSection.slideUp('fast', function(){
				$bankSection.slideDown('fast');
			});
		}
	}

	function updatePaymentPremium() {
		var product = meerkat.modules.healthResults.getSelectedProduct();

		if (!_.isEmpty(product)) {
			updateFrequencySelectOptions();
			updateProductObject(product);
		}
	}

	function updateProductFrequency() {
		var product = meerkat.modules.healthResults.getSelectedProduct();
		updateProductObject(product);
		updateLHCText(product);
	}

	function updateProductObject(product) {
		// due to the new model, need to reset the premium node
		product.paymentNode = getPaymentMethodNode();
		product.premium = product.paymentTypePremiums[product.paymentNode];
		product._selectedFrequency = getSelectedFrequency();

		if (meerkat.modules.healthDualPricing.isDualPricingActive()) {
			product.altPremium = product.paymentTypeAltPremiums[product.paymentNode];
		}

        meerkat.modules.healthResults.setSelectedProduct(product, true);
	}

	function getPaymentMethodNode(method){
		var nodeName = '';
		method = method || getSelectedPaymentMethod();

		switch (method) {
			case 'cc': nodeName = 'CreditCard';	break;
			default: nodeName = 'BankAccount'; break;
		}

		return nodeName;
	}

	function updateLHCText(product) {
		var lhcText = "";

		if (product.paymentTypePremiums[product.paymentNode] && product.paymentTypePremiums[product.paymentNode][product._selectedFrequency]) {
			lhcText = product.paymentTypePremiums[product.paymentNode][product._selectedFrequency].pricing;
		}

		$paymentMethodLHCText.html(lhcText);
	}

	function setDefaultFields() {
		// default values are sent over when the premium is loaded for the first time on this page
		// and the code below essentially sets the visual aspect of the payment page.
		if (_.isEmpty($paymentCalendar.val())) {
			$paymentCalendar.datepicker("update", new Date());
		}

		if (!$('.agg_privacy').hasClass('has-field-values-cc') && !$('.agg_privacy').hasClass('has-field-values-ba')) {
			// had to revert this back to a trigger as fund messaging wasn't being set otherwise
            $paymentRadioGroup.find('input').filter('[value=ba]').trigger('click');
		} else {
            $paymentRadioGroup.find('input').filter(':checked').trigger('click');
		}

		// Essential to ensure default copy if shown when loading a quote
		$("#health_payment_details_frequency").trigger("change." + (meerkat.modules.healthResults.getSelectedProduct().info.provider));
	}

	// Check if details for the claims bank account needs to be shown
	function toggleClaimsBankAccountQuestion(){

		var _type = getSelectedPaymentMethod();

		if(_type == 'cc'){

			// Show sub question? (always no)
			toggleClaimsBankSubQuestion(false);

			// Show form?
			if($bankAccountDetailsRadioGroup.find("input:checked").val() === 'Y' || (settings.creditBankQuestions === true && $bankAccountDetailsRadioGroup.is(':visible') === false)){
				toggleClaimsBankAccountForm(true);
			}else{
				toggleClaimsBankAccountForm(false);
			}

		} else {

			// Show sub question?
			if($bankAccountDetailsRadioGroup.find('input:checked').val() === 'Y' || (settings.creditBankQuestions === true && $bankAccountDetailsRadioGroup.is(':visible') === false)){
				toggleClaimsBankSubQuestion(true);

				// Show form?
				if($sameBankAccountRadioGroup.find("input:checked").val() === 'N'){
					toggleClaimsBankAccountForm(true);
				}else{
					toggleClaimsBankAccountForm(false);
				}

			}else{
				toggleClaimsBankSubQuestion(false);
				toggleClaimsBankAccountForm(false);
			}
		}
	}

	// What day would you like your payment deducted?
	function updatePaymentDayOptions() {

		var selected_bank_day = $("#health_payment_bank_day").val();
		var selected_credit_day = $("#health_payment_credit_day").val();

		$("#health_payment_bank_day").empty().append("<option id='health_payment_bank_day_' value='' >Please choose...</option>");
		$("#health_payment_credit_day").empty().append("<option id='health_payment_credit_day_' value='' >Please choose...</option>");

		var option_count;
		var selectedFrequency = getSelectedFrequency();
		if(selectedFrequency !== ''){
			option_count = settings.frequency[getSelectedFrequency()];
		}else{
			option_count = 27; // This is the known minimum
		}

		for(var i=1; i <= option_count; i++){
			$("#health_payment_bank_day").append("<option id='health_payment_bank_day_" + i + "' value='" + i + "'>" + i + "<" + "/option>");
			$("#health_payment_credit_day").append("<option id='health_payment_credit_day_" + i + "' value='" + i + "'>" + i + "<" + "/option>");
		}

		if( selected_bank_day ) {
			$("#health_payment_bank_day").val( selected_bank_day );
		}

		if( selected_credit_day ) {
			$("#health_payment_credit_day").val( selected_credit_day );
		}
	}

	// Render the claims details
	function toggleClaimsBankSubQuestion(show){
		if( show ) {
			$('.health_bank-details_claims_group').slideDown();
		} else {
			$('.health_bank-details_claims_group').slideUp();
		}
	}

	function toggleClaimsBankAccountForm(show){
		// Bank details form
		if( show ) {
			$('.health-bank_claim_details').slideDown();
		} else {
			$('.health-bank_claim_details').slideUp();
		}
	}

	// Hook into: (replacement) "update premium" button to determine which panels to display
	function updateValidationSelectorsPaymentGateway(functionToCall, name){
		$('#health_payment_details_type input').on('click.' + name, functionToCall);
		$('#health_payment_details_frequency').on('change.' + name, functionToCall);
		$('#health_payment_details_start').on('changeDate.' + name, functionToCall);
	}

	// Reset Hook into "update premium"
	function resetValidationSelectorsPaymentGateway( name){
        $('#health_payment_details_type input').off('click.' + name);
        $('#health_payment_details_frequency').off('change.' + name);
        $('#health_payment_details_start').off('changeDate.' + name);

        if (_.has(meerkat.site, 'hasTouchF') && meerkat.site.hasTouchF) {
            $('.agg_privacy')
				.removeClass('has-field-values-cc')
				.find('.payment-complete-text').remove();
		}
	}

    function setCoverStartToNextDay() {
        var today = new Date(),
            nextDay = today.setDate(today.getDate() + 1);

        nextDay = new Date(nextDay);

        var day = nextDay.getDay();

        if (!_startDateWeekends && _.indexOf([0,6], day) !== -1) {
            nextDay.setDate(nextDay.getDate() + (day === 0 ? 1 : 2));
        }

        $paymentCalendar.datepicker("update", nextDay);
    }

	function setCoverStartDaysOfWeekDisabled(daysOfWeekDisabled) {
        _startDateWeekends = daysOfWeekDisabled === "";

        $paymentCalendar.datepicker('setDaysOfWeekDisabled', daysOfWeekDisabled);
	}

	function getCoverStartVal() {
        return $paymentCalendar.val();
	}

	function setCoverStartValues() {
        // Change min and max dates for start date picker based on current stored values from healthPaymentStep module which can change based on selected fund
        var min = settings.minStartDate,
			max = settings.maxStartDate;

        $paymentCalendar
            .removeRule('earliestDateEUR')
            .removeRule('latestDateEUR')
            .addRule('earliestDateEUR', min, 'Please enter a date on or after ' + min)
            .addRule('latestDateEUR', max, 'Please enter a date on or before ' + max)
            .datepicker('setStartDate', min)
						.datepicker('setEndDate', max)
						.datepicker("update", min);
	}

	function toggleCouponSeenText() {
        var Coupon = meerkat.modules.coupon,
			$couponCampaignSeen = $('.coupon-campaign-seen'),
        	couponId = Coupon.getCouponViewedId(),
			coupon = null;

        // show only if outbound or trial campaign
		if (!_.isNull(couponId) && meerkat.modules.simplesBindings.getCallType() === 'outbound') {
        	if ($couponCampaignSeen.length === 1) {
                $couponCampaignSeen.show();
			} else {
                Coupon.loadCoupon('simplesCouponLoad', couponId, function() {
                    coupon = Coupon.getCurrentCoupon();

                    if (_.isObject(coupon) && coupon.showCouponSeen) {
						$('<div class="coupon-campaign-seen alert alert-info">Coupon Campaign: ' + coupon.campaignName + ' | Coupon Value: $' + coupon.couponValue + '</div>')
							.insertAfter($('#healthVouchers'));
                    } else {
                        $couponCampaignSeen.hide();
					}
                });
			}
        } else {
            $couponCampaignSeen.hide();
        }
	}

	meerkat.modules.register("healthPaymentStep", {
		init: initHealthPaymentStep,
		initFields: initFields,
		events: moduleEvents,
		getSetting: getSetting,
		overrideSettings: overrideSettings,
		setCoverStartRange: setCoverStartRange,
		getSelectedFrequency: getSelectedFrequency,
		getSelectedPaymentMethod: getSelectedPaymentMethod,
		updatePremium: updatePremium,
		getPaymentMethodNode: getPaymentMethodNode,
		rebindCreditCardRules: rebindCreditCardRules,
		updateValidationSelectorsPaymentGateway : updateValidationSelectorsPaymentGateway,
		resetValidationSelectorsPaymentGateway : resetValidationSelectorsPaymentGateway,
        setCoverStartToNextDay: setCoverStartToNextDay,
		setCoverStartDaysOfWeekDisabled: setCoverStartDaysOfWeekDisabled,
        getCoverStartVal: getCoverStartVal,
		setCoverStartValues: setCoverStartValues,
        toggleCouponSeenText: toggleCouponSeenText
	});

})(jQuery);