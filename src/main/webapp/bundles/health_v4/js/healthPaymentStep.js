;(function($, undefined){

	var meerkat = window.meerkat,
		meerkatEvents = meerkat.modules.events;

	var moduleEvents = {
		WEBAPP_LOCK: 'WEBAPP_LOCK',
		WEBAPP_UNLOCK: 'WEBAPP_UNLOCK',
		TRIGGER_UPDATE_PREMIUM: 'TRIGGER_UPDATE_PREMIUM'
	};

	var modalId;
	var $paymentRadioGroup;
	var $paymentContainer;
	var $paymentMethodLHCText;
	var $bankSection;
	var $creditCardSection;
	var $frequencySelect;

	var settings = {
		bank: [],
		credit: [],
		frequency: [],
		creditBankSupply: false,
		creditBankQuestions: false
	};

	var currentCoupon = false;

	function initHealthPaymentStep() {

		$(document).ready(function() {
			initialised = true;

			if(meerkat.site.vertical !== "health" || meerkat.site.pageAction === "confirmation") return false;

			// Fields
			initFields();
			_eventSubscriptions();
			_applyEventListeners();

			$('#health_coupon_code').blur(validateCoupon);

			meerkat.modules.healthCreditCard.setCreditCardRules();

			resetSettings();

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

		// Containers
		$paymentContainer = $(".update-content");
	}

	function _eventSubscriptions() {
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

		meerkat.messaging.subscribe(meerkatEvents.TRIGGER_UPDATE_PREMIUM, function triggerUpdatePremium(){
			updatePremium();
		});
	}

	function _applyEventListeners() {
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

		$frequencySelect.on('change', function updateSidebarQuote(){
			updateProductFrequency();
			updatePaymentDayOptions();
		});

		// show pay claims into bank account question (and supporting section).
		$bankAccountDetailsRadioGroup.find("input").on('click', toggleClaimsBankAccountQuestion);

		// show pay claims into bank account question (and supporting section).
		$sameBankAccountRadioGroup.find("input").on('click', toggleClaimsBankAccountQuestion);

		// Moved from fields:card_expiry.tag as part of CTMIT-555
		$("select[id$='_cardExpiryMonth']").on('change', function() {
			var $year = $("select[id$='_cardExpiryYear']");
			if ($year.hasClass('has-error') || $year.hasClass('has-success')) {
				$year.valid();
			}
		});
		// Moved from field_new:bsb_number
		$(".bsb_number").on("focus blur", function() {
			var $self = $(this), id = $self.attr('id'),
				hiddenInput = id.substring(0,id.length - 5);
			$("#"+hiddenInput).val( String($self.val()).replace(/[^0-9]/g, '') );
		}).each(function() {
			// blur both on load.
			$(this).blur();
		});

		$("#joinDeclarationDialog_link").on('click',function(){
			var selectedProduct = meerkat.modules.healthResults.getSelectedProduct();
			var data = {};
			data.providerId = selectedProduct.info.providerId;
			data.providerContentTypeCode = meerkat.site.isCallCentreUser === true ? 'JDC' : 'JDO';
            data.styleCode = meerkat.site.tracking.brandCode;

			meerkat.modules.comms.get({
				url: "health/provider/content/get.json",
				data: data,
				cache: true,
				errorLevel: "silent",
				onSuccess: function getProviderContentSuccess(result) {
					if (result.hasOwnProperty('providerContentText')) {
                        var callback = function applyCustomisedProviderContentCallback(content) {
                            meerkat.modules.dialogs.show({
                                title: 'Declaration',
                                htmlContent : content
                            });
                        };
                        // Call function to update placeholder copy
                        applyCustomisedProviderContent(selectedProduct, result.providerContentText, callback);
					}
				}
			});

			meerkat.messaging.publish(meerkatEvents.tracking.EXTERNAL, {
				method:'trackOfferTerms',
				object:{
					productID:selectedProduct.productId
				}
			});

		});
	}

	function validateCoupon() {
		var couponInput = $('.coupon-code-field').val();
		if(currentCoupon === false || currentCoupon !== couponInput) {
			currentCoupon = couponInput;
			meerkat.modules.coupon.validateCouponCode(currentCoupon);
		}
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
		meerkat.modules.healthCoverStartDate.flush();

		// Clear payment method selection
		$paymentRadioGroup.find('input').prop('checked', false).change();
		$paymentRadioGroup.find('label').removeClass('active');

		// Clear frequency selection
		$frequencySelect.val('');

		// Clear bank account details selection
		$("#health_payment_details_claims input").prop('checked', false).change().find('label').removeClass('active');

		meerkat.modules.healthCoverStartDate.setCoverStartRange(0, 90);

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

		// Datepicker
		meerkat.modules.healthCoverStartDate.enable();
	}

	function disableUpdatePremium(isSameSource, disableFields) {

		if(disableFields === true){
			// Disable the other premium-related inputs
			var $paymentSection = $('#health_payment_details-selection');

			$paymentSection.find(':input').prop('disabled', true);
			$paymentSection.find('.select').addClass('disabled');
			$paymentSection.find('.btn-group label').addClass('disabled');

			// Datepicker
			meerkat.modules.healthCoverStartDate.disable();
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

	function getPaymentMethodNode(){
		var nodeName = '';

		switch (getSelectedPaymentMethod()) {
			case 'cc':
				var label = $paymentRadioGroup.find('label.active').text().trim();

				if (label == 'Credit Card') {
					nodeName = 'CreditCard';
				} else {
					nodeName = 'Invoice';
				}
				break;
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

		meerkat.modules.healthCoverStartDate.setDefault();

		if (!$("#health_payment_details_type_cc").is(':checked')) {
			// had to revert this back to a trigger as fund messaging wasn't being set otherwise
			$paymentRadioGroup.find('input').filter('[value=ba]').trigger('click');
		}

		// Essential to ensure default copy if shown when loading a quote
		$("#health_payment_details_frequency").trigger("change." + (meerkat.modules.healthResults.getSelectedProduct().info.FundCode));
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
		meerkat.modules.healthCoverStartDate.updateValidationSelectorsPaymentGateway(functionToCall, name);
	}

	// Reset Hook into "update premium"
	function resetValidationSelectorsPaymentGateway(name){
        $('#health_payment_details_type input').off('click.' + name);
        $('#health_payment_details_frequency').off('change.' + name);
		meerkat.modules.healthCoverStartDate.resetValidationSelectorsPaymentGateway(name);
	}

    /**
     * applyCustomisedProviderContent() method to replace placeholder content with product
     * specific copy. The expected placeholders and the objects containing their values
     * are stored in content_control/supplementary.
     * @param product Object
     * @param content String
     * @param callback Function
     */
    function applyCustomisedProviderContent(product, content, callback) {
        meerkat.modules.comms.get({
            url: "spring/content/getsupplementary.json",
            data: {
                vertical: 'HEALTH',
                key: 'healthJoinDecVariables'
            },
            cache: true,
            errorLevel: "silent",
            onSuccess: function getProviderContentSuccess(resultData) {
                if(_.isObject(resultData) && _.has(resultData,'supplementary') && !_.isEmpty(resultData.supplementary) && _.isArray(resultData.supplementary)) {
                    // Lint safe method to EVAL basic strings
                    var evalString = function (str, contexta) {
                        contexta = contexta || window;
                        var evalStringSimple = function(str, contextb) {
                            contextb = contextb || window;
                            var namespaces = str.split(".");
                            var prop = namespaces.pop();
                            namespaces.shift();
                            for (var i = 0; i < namespaces.length; i++) {
                                contextb = contextb[namespaces[i]];
                            }
                            return contextb[prop];
                        };
                        // If str contains square brackets then execute that first
                        var exp = /\[(.)+\]/gi;
                        if(exp.test(str)) {
                            var sub = str.match(exp)[0].replace("[","").replace("]","");
                            var subval = evalStringSimple(sub, contexta);
                            str = str.replace(exp,"." + subval);
                        }
                        return evalStringSimple(str, contexta);
                    };

                    /**
                     * Cycle through each key/value defined in content_supplementary and
                     * use to replace the placeholders in the copy.
                     */
                    for(var i=0; i < resultData.supplementary.length; i++) {
                        var supp = resultData.supplementary[i];
                        var regex = new RegExp("\\[" + supp.supplementaryKey + "\\]","gi");
                        content = content.replace(regex,evalString(supp.supplementaryValue, product));
                    }
                }
            },
            onComplete: function() {
                callback(content);
            }
        });
    }

	meerkat.modules.register("healthPaymentStep", {
		init: initHealthPaymentStep,
		initFields: initFields,
		events: moduleEvents,
		getSetting: getSetting,
		overrideSettings: overrideSettings,
		getSelectedFrequency: getSelectedFrequency,
		getSelectedPaymentMethod: getSelectedPaymentMethod,
		updatePremium: updatePremium,
		getPaymentMethodNode: getPaymentMethodNode,
		rebindCreditCardRules: rebindCreditCardRules,
		updateValidationSelectorsPaymentGateway : updateValidationSelectorsPaymentGateway,
		resetValidationSelectorsPaymentGateway : resetValidationSelectorsPaymentGateway
	});

})(jQuery);