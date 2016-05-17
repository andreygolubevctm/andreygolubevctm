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

	var $frequencySelect;

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

	function initHealthPaymentStep() {

		$(document).ready(function(){
			initialised = true;

			if(meerkat.site.vertical !== "health" || meerkat.site.pageAction === "confirmation") return false;

			// Fields
			$paymentRadioGroup = $("#health_payment_details_type");
			$frequencySelect = $("#health_payment_details_frequency");
			$bankAccountDetailsRadioGroup = $("#health_payment_details_claims");
			$sameBankAccountRadioGroup = $("#health_payment_bank_claims");
			$paymentMethodLHCText = $('.changes-premium .lhcText');
			$bankSection = $('#health_payment_bank-selection');
			$creditCardSection = $('#health_payment_credit-selection');
			$paymentCalendar = $('#health_payment_details_start');

			// Containers
			$paymentContainer = $(".update-content");

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

			$paymentRadioGroup.find('input').on('change', function() {
				togglePaymentGroups();
				toggleClaimsBankAccountQuestion();
			});

			// Update premium button
			$('#health_payment_details_type input').on('click', function(){
				// validate coupon
				meerkat.modules.coupon.validateCouponCode($('.coupon-code-field').val());
				updatePaymentPremium();
			});

			$frequencySelect.on('change', function updateSidebarQuote(){
				updateProductFrequency();
				updatePaymentDayOptions();
			});

			$('#health_payment_credit_type').on('change', meerkat.modules.healthCreditCard.setCreditCardRules);
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

			// Set Dom state
			$paymentContainer.hide();

		});
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
		$paymentRadioGroup.find('input').prop('checked', false).change();
		$paymentRadioGroup.find('label').removeClass('active');

		// Clear frequency selection
		$frequencySelect.val('');

		// Clear bank account details selection
		$("#health_payment_details_claims input").prop('checked', false).change().find('label').removeClass('active');

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
		settings.minStartDateOffset = min;
		settings.maxStartDateOffset = max;

		// Get today's date in UTC timezone
		var today = meerkat.modules.utils.getUTCToday(),
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
		settings.minStartDate = today.getUTCDate() + '/' + (today.getUTCMonth()+1) + '/' + today.getUTCFullYear();
		today = new Date(end);
		settings.maxStartDate = today.getUTCDate() + '/' + (today.getUTCMonth()+1) + '/' + today.getUTCFullYear();

	}

	// Show approved listings only, this can potentially change per fund
	function updateFrequencySelectOptions(){
		var premiums = meerkat.modules.healthResults.getSelectedProduct();

		if (!_.isEmpty(premiums) && !_.isEmpty(premiums.paymentTypePremiums)) {
			premiums.paymentNode = getPaymentMethodNode();
			premiums._selectedFrequency = getSelectedFrequency();

			var htmlTemplate = _.template($('#payment_frequency_options').html());
			var options = htmlTemplate(premiums);

			$frequencySelect.empty().append(options);

			updateLHCText(premiums);
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

		meerkat.messaging.publish(moduleEvents.WEBAPP_LOCK, { source: 'healthPaymentStep', disableFields:true });

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

					updateCurrentProduct(data);

					// Show payment input questions
					$paymentContainer.show();

					togglePaymentGroups();

					// Show declaration checkbox
					$(".health_declaration-group").slideDown();

					toggleClaimsBankAccountQuestion();

					//re-set the days if required
					updatePaymentDayOptions();

					updateFrequencySelectOptions();

					$("#confirm-step").show();
					$(".simples-dialogue-31").show();

					// TODO work out this: //Results._refreshSimplesTooltipContent($('#update-premium .premium'));
				}

				if (typeof meerkat.site.healthAlternatePricingActive !== 'undefined' && meerkat.site.healthAlternatePricingActive === true) {
					meerkat.modules.healthDualPricing.renderTemplate('.policySummary.dualPricing', data, false, true);
				}

				meerkat.messaging.publish(moduleEvents.WEBAPP_UNLOCK, { source: 'healthPaymentStep' });

				setDefaultFields();
			});
		});
	}

	function togglePaymentGroups() {
		if(getSelectedPaymentMethod() === 'cc' ) {
			$bankSection.slideUp('slow', function(){
				$creditCardSection.slideDown();
			});
		} else {
			$creditCardSection.slideUp('slow', function(){
				$bankSection.slideDown();
			});
		}
	}

	function updatePaymentPremium() {
		var product = meerkat.modules.healthResults.getSelectedProduct();

		if (!_.isEmpty(product)) {
			var freq = !_.isEmpty(product._selectedFrequency) ? product._selectedFrequency : Results.getFrequency();
			product._selectedFrequency = freq;
			product.premium = product.paymentTypePremiums[getPaymentMethodNode(freq)];

			meerkat.modules.healthResults.setSelectedProduct(product, true);
			updateFrequencySelectOptions();
		}
	}

	function updateProductFrequency() {
		var product = meerkat.modules.healthResults.getSelectedProduct();
		product._selectedFrequency = getSelectedFrequency();
		product.paymentNode = getPaymentMethodNode();
		meerkat.modules.healthResults.setSelectedProduct(product, true);

		updateLHCText(product);
	}

	function updateCurrentProduct(data) {
		var freq = !_.isEmpty(data._selectedFrequency) ? data._selectedFrequency : Results.getFrequency();

		// due to the new model, need to reset the premium node
		data.premium = data.paymentTypePremiums[getPaymentMethodNode()];
		data._selectedFrequency = freq;

		// Update selected product
		meerkat.modules.healthResults.setSelectedProduct(data, true);
	}

	function getPaymentMethodNode(freq){
		var nodeName = '';
			freq = (_.isEmpty(freq) ? getSelectedPaymentMethod() : freq);

		switch (freq) {
			case 'cc': nodeName = 'CreditCard'; break;
			default: nodeName = 'BankAccount'; break;
		}

		return nodeName;
	}

	function updateLHCText(premiums) {
		var lhcText = "";

		if (premiums.paymentTypePremiums[premiums.paymentNode] && premiums.paymentTypePremiums[premiums.paymentNode][premiums._selectedFrequency]) {
			lhcText = premiums.paymentTypePremiums[premiums.paymentNode][premiums._selectedFrequency].pricing;
		}

		$paymentMethodLHCText.html(lhcText);
	}

	function setDefaultFields() {
		// default values are sent over when the premium is loaded for the first time on this page
		// and the code below essentially sets the visual aspect of the payment page.
		if (_.isEmpty($paymentCalendar.val())) {
			$paymentCalendar.datepicker("update", new Date());
		}

		// $paymentRadioGroup.find('input').filter('[value=ba]').trigger('click');
		$paymentRadioGroup.find('input').filter('[value=ba]').prop('checked', true).closest('label').addClass('active');
	}

	// Check if details for the claims bank account needs to be shown
	function toggleClaimsBankAccountQuestion(){

		var _type = getSelectedPaymentMethod();

		if(_type == 'ba'){

			// Show sub question?
			if($bankAccountDetailsRadioGroup.find('input:checked').val() == 'Y' || (settings.creditBankQuestions === true && $bankAccountDetailsRadioGroup.is(':visible') === false)){
				toggleClaimsBankSubQuestion(true);
			}else{
				toggleClaimsBankSubQuestion(false);
			}

			// Show form?
			if($sameBankAccountRadioGroup.find("input:checked").val() == 'N'){
				toggleClaimsBankAccountForm(true);
			}else{
				toggleClaimsBankAccountForm(false);
			}

		}else if(_type == 'cc'){

			// Show sub question? (always no)
			toggleClaimsBankSubQuestion(false);

			// Show form?
			if($bankAccountDetailsRadioGroup.find("input:checked").val() == 'Y' || (settings.creditBankQuestions === true && $bankAccountDetailsRadioGroup.is(':visible') === false)){
				toggleClaimsBankAccountForm(true);
			}else{
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

	meerkat.modules.register("healthPaymentStep", {
		init: initHealthPaymentStep,
		events: moduleEvents,
		getSetting: getSetting,
		overrideSettings: overrideSettings,
		setCoverStartRange: setCoverStartRange,
		getSelectedFrequency: getSelectedFrequency,
		getSelectedPaymentMethod: getSelectedPaymentMethod,
		updatePremium: updatePremium,
		getPaymentMethodNode: getPaymentMethodNode
	});

})(jQuery);