;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events;

	var moduleEvents = {
			WEBAPP_LOCK: 'WEBAPP_LOCK',
			WEBAPP_UNLOCK: 'WEBAPP_UNLOCK'
		};

	var modalId;
	var $coverStartDate;
	var $paymentRadioGroup;
	var $premiumContainer;
	var $updatePremiumButtonContainer;
	var $paymentContainer;

	var $frequencySelect;
	var $priceCell;
	var $frequncyCell;
	var $lhcCell;

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

	function init() {

		$(document).ready(function(){

			if(meerkat.site.vertical !== "health" || meerkat.site.pageAction === "confirmation") return false;

			// Fields
			$coverStateDate = $('#health_payment_details_start');
			$coverStateDateCalendar = $('#health_payment_details_start_calendar');
			$paymentRadioGroup = $("#health_payment_details_type");
			$frequencySelect = $("#health_payment_details_frequency");
			$bankAccountDetailsRadioGroup = $("#health_payment_details_claims");
			$sameBankAccountRadioGroup = $("#health_payment_bank_claims");

			// Containers
			$updatePremiumButtonContainer = $(".health-payment-details_update");
			$paymentContainer = $("#update-content");


			$premiumContainer = $(".health-payment-details_premium");
			$priceCell = $premiumContainer.find(".amount");
			$frequncyCell = $premiumContainer.find(".frequencyText");
			$lhcCell = $premiumContainer.find(".lhcText");


			// Add event listeners
			meerkat.messaging.subscribe(meerkatEvents.WEBAPP_LOCK, function lockPaymentStep(obj) {
				var isSameSource = (typeof obj !== 'undefined' && obj.source && obj.source === 'healthPaymentStep');
				var disableFields = (typeof obj !== 'undefined' && obj.disableFields && obj.disableFields === true);
				disableUpdatePremium(isSameSource, disableFields);
			});

			meerkat.messaging.subscribe(meerkatEvents.WEBAPP_UNLOCK, function unlockPaymentStep(obj) {
				enableUpdatePremium();
			});

			meerkat.messaging.subscribe(meerkatEvents.health.CHANGE_MAY_AFFECT_PREMIUM, resetState);

			meerkat.messaging.subscribe(meerkatEvents.healthResults.SELECTED_PRODUCT_RESET, function jeStepChange(step){
				resetState();
				resetSettings();
			});

			$paymentRadioGroup.find('input').on('change', updateFrequencySelectOptions);

			// validate coupon
			$('#update-premium').on('click', function(){
				meerkat.modules.coupon.validateCouponCode($('.coupon-code-field').val());
			});

			// reset state when change coupon code to bring update premium button back
			$('.coupon-code-field').on('change', resetState);

			// Update premium button
			$('#update-premium').on('click', updatePremium);

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

			resetSettings();

			// Set Dom state
			$premiumContainer.hide();
			$updatePremiumButtonContainer.show();
			$paymentContainer.hide();

		});
	}

	// Reset the step
	function resetState(){

		$premiumContainer.hide();
		$updatePremiumButtonContainer.show();
		$paymentContainer.hide();
		$("#health_declaration-selection").hide();
		$("#confirm-step").hide();
		$(".simples-dialogue-31").hide();

		$('#update-premium').removeClass("hasAltPremium"); // TODO WORK OUT ALT PREMIUM STUFF

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

		$("#health_payment_details_start").val('');

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
		return $frequencySelect.val();
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

		//console.log(settings.minStartDate, settings.maxStartDate);
	}

	// Show approved listings only, this can potentially change per fund
	function updateFrequencySelectOptions(){

		var paymentMethod = getSelectedPaymentMethod();
		var selectedFrequency = getSelectedFrequency();
		var product = meerkat.modules.healthResults.getSelectedProduct();

		var _html = '<option id="health_payment_details_frequency_" value="">Please choose...</option>';

		if(paymentMethod === '' || product === null){
			return false;
		}

		var method;

		if(paymentMethod === 'cc'){
			method = settings.credit;
		}else if(paymentMethod === 'ba'){
			method = settings.bank;
		}else{
			return false;
		}

		var premium = product.premium;

		if( method.weekly === true && premium.weekly.value > 0 ){
			_html += '<option id="health_payment_details_frequency_W" value="weekly">Weekly</option>';
		}

		if( method.fortnightly === true && premium.fortnightly.value > 0 ){
			_html += '<option id="health_payment_details_frequency_F" value="fortnightly">Fortnightly</option>';
		}

		if( method.monthly === true && premium.monthly.value > 0 ){
			_html += '<option id="health_payment_details_frequency_M" value="monthly">Monthly</option>';
		}

		if( method.quarterly === true && premium.quarterly.value > 0 ){
			_html += '<option id="health_payment_details_frequency_Q" value="quarterly">Quarterly</option>';
		}

		if( method.halfyearly === true && premium.halfyearly.value > 0 ){
			_html += '<option id="health_payment_details_frequency_H" value="halfyearly">Half-yearly</option>';
		}

		if( method.annually === true && premium.annually.value > 0){
			_html += '<option id="health_payment_details_frequency_A" value="annually">Annually</option>';
		}

		$frequencySelect.html( _html ).find('option[value="'+ selectedFrequency +'"]').attr('selected', 'SELECTED');
	}



	// Update premium button
	function enableUpdatePremium() {
		// Enable button, hide spinner
		var $button = $('#update-premium');
		$button.removeClass('disabled');

		// Enable the other premium-related inputs
		// Ignore fields that were specifically disabled by funds' rules.
		var $paymentSection = $('#health_payment_details-selection');
		$paymentSection.find(':input').not('.disabled-by-fund').prop('disabled', false);
		$paymentSection.find('.select').not('.disabled-by-fund').removeClass('disabled');
		$paymentSection.find('.btn-group label').not('.disabled-by-fund').removeClass('disabled');

		// Non-inline datepicker
		//$('#health_payment_details_start').parent().addClass('input-group').find('.input-group-addon').removeClass('hidden');
		// Inline datepicker
		$('#health_payment_details_start').parent().find('.datepicker').children().css('visibility', 'visible');

		meerkat.modules.loadingAnimation.hide($button);
	}

	function disableUpdatePremium(isSameSource, disableFields) {
		// Disable button, show spinner
		var $button = $('#update-premium');
		$button.addClass('disabled');

		if(disableFields === true){
			// Disable the other premium-related inputs
			var $paymentSection = $('#health_payment_details-selection');

			$paymentSection.find(':input').prop('disabled', true);
			$paymentSection.find('.select').addClass('disabled');
			$paymentSection.find('.btn-group label').addClass('disabled');

			// Non-inline datepicker
			//$('#health_payment_details_start').parent().removeClass('input-group').find('.input-group-addon').addClass('hidden');
			// Inline datepicker
			$('#health_payment_details_start').parent().find('.datepicker').children().css('visibility', 'hidden');
		}

		if (isSameSource === true) {
			meerkat.modules.loadingAnimation.showAfter($button);
		}
	}

	// Calls the server for a new premium price based on current selections.
	function updatePremium() {

		if( meerkat.modules.journeyEngine.isCurrentStepValid() === false){
			return false;
		}
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

					// Update selected product
					meerkat.modules.healthResults.setSelectedProduct(data, true);

					// Show premium, hide update premium button
					$premiumContainer.slideDown();
					$updatePremiumButtonContainer.hide();

					// Show payment input questions
					$paymentContainer.show();
					if(getSelectedPaymentMethod() === 'cc' ) {
						$('#health_payment_credit-selection').slideDown();
						$('#health_payment_bank-selection').hide();
					} else {
						$('#health_payment_bank-selection').slideDown();
						$('#health_payment_credit-selection').hide();
					}

					// Show declaration checkbox
					$("#health_declaration-selection").slideDown();

					toggleClaimsBankAccountQuestion();

					//re-set the days if required
					updatePaymentDayOptions();

					$("#confirm-step").show();
					$(".simples-dialogue-31").show();

					// TODO work out this: //Results._refreshSimplesTooltipContent($('#update-premium .premium'));
				}

				meerkat.messaging.publish(moduleEvents.WEBAPP_UNLOCK, { source: 'healthPaymentStep' });
			});
		});
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
		init: init,
		events: moduleEvents,
		getSetting: getSetting,
		overrideSettings: overrideSettings,
		setCoverStartRange: setCoverStartRange,
		getSelectedFrequency: getSelectedFrequency,
		getSelectedPaymentMethod: getSelectedPaymentMethod
	});

})(jQuery);