	window.jQuery
			&& window.jQuery.each
			|| document
					.write('<script src="C:\dev\web_ctm\WebContent\framework/jquery/lib/jquery-2.0.3.min.js">\x3C/script>')

;(function(meerkat) {

			var siteConfig = {
				title : 'Kitchen sink: Current &amp; new - Compare The Market',
				name : 'Compare The Market Australia',
				brand : 'ctm',
				vertical : 'default',
				isDev : true, //boolean determined from conditions above in this tag
				isCallCentreUser : false,
				environment : 'localhost',
				//could be: localhost, integration, qa, staging, prelive, prod
				logpath : '/ctm/ajax/write/register_fatal_error.jsp?uncache=',
				urls : {
					root : 'http://localhost:8080/',
					exit : 'http://int.comparethemarket.com.au/',
					quote : '',
					privacyPolicy : '/ctm/legal/privacy_policy.pdf',
					websiteTerms : '/ctm/legal/website_terms_of_use.pdf',
					fsg : ''
				},
				liveChat : {
					config : {
						lpServer : "server.lon.liveperson.net",
						lpTagSrv : "sr1.liveperson.net",
						lpNumber : "1563103",
						deploymentID : "1",
						pluginsConsoleDebug : false
					},
					instance : {
						brand : 'ctm',
						vertical : 'Health',
						unit : 'health-insurance-sales',
						button : 'chat-health-insurance-sales'
					}
				}
			};
			//pluginsConsoleDebug above will suppress debug console logs being output for our liveperson plugins.
			var options = {};
			meerkat != null && meerkat.init(siteConfig, options);

		})(window.meerkat);
var validation = false;
$(document).ready(function() {

	if (typeof jQuery.validator !== 'function') {
		if (typeof console.log === 'function') console.log('jquery.validate library is not available.');
		return;
	}


	jQuery.validator.prototype.hideErrors = function() {
		this.addWrapper( this.toHide );
	}


	jQuery.validator.prototype.ctm_unhighlight = function( element, errorClass, validClass ) {
		if (!element) return;
		errorClass = errorClass || this.settings.errorClass;
		validClass = validClass || this.settings.validClass;


		if (element.type === "radio") {
			this.findByName(element.name).removeClass(errorClass).addClass(validClass);
		} else {
			$(element).removeClass(errorClass).addClass(validClass);
		}


		var $wrapper = $(element).closest('.row-content, .fieldrow_value');
		var $errorContainer = $wrapper.find('.error-field');


		$errorContainer.find('label[for="' + element.name + '"]').remove();


		if ($wrapper.find(':input.has-error').length > 0) {
			return;
		}


		$wrapper.removeClass(errorClass).addClass(validClass);


		if ($errorContainer.find('label').length > 0) {
			if ($errorContainer.is(':visible')) {
				$errorContainer.stop().slideUp(100);

			}
			else {
				$errorContainer.hide();
			}
		}
	}


	$('.journeyEngineSlide form').each(function(index, element){
		setupDefaultValidationOnForm( $(element) );
	});

});


function setupDefaultValidationOnForm( $formElement ){

	$formElement.validate({
		submitHandler: function(form) {
			form.submit();
		},
		invalidHandler: function(form, validator) {

			if (!validator.numberOfInvalids()) return;
			if(jQuery.validator.scrollingInProgress == true) return;

			var $ele = $(validator.errorList[0].element),
				$parent = $ele.closest('.row-content, .fieldrow_value');


			if($ele.attr('data-validation-placement') != null && $ele.attr('data-validation-placement') != ''){
				$ele2 = $($ele.attr('data-validation-placement'));
				if ($ele2.length > 0) $ele = $ele2;
			}


			if ($parent.length > 0) $ele = $parent;
			jQuery.validator.scrollingInProgress = true;
			meerkat.modules.utilities.scrollPageTo($ele,500,-50, function(){
				jQuery.validator.scrollingInProgress = false;
			});
		},
		ignore: ':hidden,:disabled',
		//wrapper: 'li',
		meta: 'validate',
		debug: true,
		errorClass: 'has-error',
		validClass: 'has-success',
		errorPlacement: function ($error, $element) {


			var $referenceElement = $element;
			if($element.attr('data-validation-placement') != null && $element.attr('data-validation-placement') != ''){
				$referenceElement = $($element.attr('data-validation-placement'));
			}

			var parent = $referenceElement.closest('.row-content, .fieldrow_value');

			if(parent.length == 0) parent = $element.parent();

			var errorContainer = parent.children('.error-field');

			if (errorContainer.length == 0) {
				parent.prepend('<div class="error-field"></div>');
				errorContainer = parent.children('.error-field');
				errorContainer.hide().slideDown(100);
			}
			errorContainer.append($error);
		},
		onkeyup: function(element) {
			var element_id = jQuery(element).attr('id');
			if ( !this.settings.rules.hasOwnProperty(element_id) || this.settings.rules[element_id].onkeyup == false) {
				return;
			};

			if (validation && element.name != "captcha_code") {
				this.element(element);
			};
		},
		onfocusout: function(element, event) {

			var $ele = $(element);
			if ($ele.hasClass('tt-query')) {
				var $menu = $ele.nextAll('.tt-dropdown-menu');
				if ($menu.length > 0 && $menu.first().is(':visible')) {
					return false;
				}
			}


			$.validator.defaults.onfocusout.call(this, element, event);
		},
		highlight: function( element, errorClass, validClass ) {

			if (element.type === "radio") {
				this.findByName(element.name).addClass(errorClass).removeClass(validClass);
			} else {
				$(element).addClass(errorClass).removeClass(validClass);
			}


			var $wrapper = $(element).closest('.row-content, .fieldrow_value');
			$wrapper.addClass(errorClass).removeClass(validClass);


			var errorContainer = $wrapper.find('.error-field');
			if (errorContainer.find('label:visible').length === 0) {
				if (errorContainer.is(':visible')) {
					errorContainer.stop();
				}
				errorContainer.delay(10).slideDown(100);

			}
		},
		unhighlight: function( element, errorClass, validClass ) {
			return this.ctm_unhighlight( element, errorClass, validClass );
		}
	});
}

window._
				|| document
						.write('<script src="C:/dev/web_ctm/WebContent/framework/lib/js/underscore-1.5.2.min.js">\x3C/script>')

$(document).ready( function(){
	var vertical = "health";;
	var frequency="Monthly";

	meerkat.site =  {
		title: 'Health Quote - Compare The Market Australia',
		name: 'Compare the Market',
		vertical: vertical,
		quoteType: vertical,
		isDev: true, //boolean determined from conditions above in this tag
		isCallCentreUser: false,
		showLogging: true,
		environment: 'localhost',
		//could be: localhost, integration, qa, staging, prelive, prod
		initialTransactionId: 2204245,
		// DO NOT rely on this variable to get the transaction ID, it gets wiped by the transactionId module. Use transactionId.get() instead
		urls:{
			base: 'http://localhost:8080/ctm/',
			exit: 'http://int.comparethemarket.com.au/health-insurance/'
		},
		content:{
			brandDisplayName: 'comparethemarket.com.au'
		},
		//This is just for supertag tracking module, don't use it anywhere else
		tracking:{
			brandCode: 'ctm'
		},
		leavePageWarning: {
			enabled: true,
			message: "You're leaving?! Before you go, why don't you save your quote so you can easily review your health insurance options at a later date"
		},
		liveChat: {
			config: {},
			instance: {},
			enabled: false
		},
		navMenu: {
			type: 'default',
			direction: 'right'
		},
		useNewLogging: true
	};

	meerkat.modules.transactionId.set = function(transactionId){

	};

	// mock out server call
	meerkat.modules.optIn = {
			fetch : function(settings){
				var result = {
						optInMarketing : true
				};
				settings.onSuccess(result);
			}
	};

	Results = {
			settings :
				{
					frequency : frequency
				}
	};

});

function getProduct() {
	return {
			transactionId: 2204639,
			ambulance:  {

			},
			promo: {

			},
			premium: {
				annually: {
					base: "$2,351.44",
					baseAndLHC: "$2,669.24",
					discounted: "N",
					hospitalValue: 2187.2,
					lhc: 317.8,
					lhcfreepricing: "+ $317.80 LHC inc $0.00 Government Rebate",
					lhcfreetext: "$2,351.44",
					lhcfreevalue: 2351.44,
					pricing: "Includes rebate of $0.00 & LHC loading of $317.80",
					rebate: "",
					rebateValue: "$0.00",
					text: "$2,669.24",
					value: 2669.24
				},
				fortnightly: {
					base: "$2,351.44",
					baseAndLHC: "$2,669.24",
					discounted: "N",
					hospitalValue: 2187.2,
					lhc: 317.8,
					lhcfreepricing: "+ $317.80 LHC inc $0.00 Government Rebate",
					lhcfreetext: "$2,351.44",
					lhcfreevalue: 2351.44,
					pricing: "Includes rebate of $0.00 & LHC loading of $317.80",
					rebate: "",
					rebateValue: "$0.00",
					text: "$2,669.24",
					value: 2669.24
				},
				halfyearly: {
					base: "$2,351.44",
					baseAndLHC: "$2,669.24",
					discounted: "N",
					hospitalValue: 2187.2,
					lhc: 317.8,
					lhcfreepricing: "+ $317.80 LHC inc $0.00 Government Rebate",
					lhcfreetext: "$2,351.44",
					lhcfreevalue: 2351.44,
					pricing: "Includes rebate of $0.00 & LHC loading of $317.80",
					rebate: "",
					rebateValue: "$0.00",
					text: "$2,669.24",
					value: 2669.24
				},
				monthly: {
					base: "$2,351.44",
					baseAndLHC: "$2,669.24",
					discounted: "N",
					hospitalValue: 2187.2,
					lhc: 317.8,
					lhcfreepricing: "+ $317.80 LHC inc $0.00 Government Rebate",
					lhcfreetext: "$2,351.44",
					lhcfreevalue: 2351.44,
					pricing: "Includes rebate of $0.00 & LHC loading of $317.80",
					rebate: "",
					rebateValue: "$0.00",
					text: "$2,669.24",
					value: 2669.24
				},
				quarterly: {
					base: "$2,351.44",
					baseAndLHC: "$2,669.24",
					discounted: "N",
					hospitalValue: 2187.2,
					lhc: 317.8,
					lhcfreepricing: "+ $317.80 LHC inc $0.00 Government Rebate",
					lhcfreetext: "$2,351.44",
					lhcfreevalue: 2351.44,
					pricing: "Includes rebate of $0.00 & LHC loading of $317.80",
					rebate: "",
					rebateValue: "$0.00",
					text: "$2,669.24",
					value: 2669.24
				},
				weekly: {
					base: "$2,351.44",
					baseAndLHC: "$2,669.24",
					discounted: "N",
					hospitalValue: 2187.2,
					lhc: 317.8,
					lhcfreepricing: "+ $317.80 LHC inc $0.00 Government Rebate",
					lhcfreetext: "$2,351.44",
					lhcfreevalue: 2351.44,
					pricing: "Includes rebate of $0.00 & LHC loading of $317.80",
					rebate: "",
					rebateValue: "$0.00",
					text: "$2,669.24",
					value: 2669.24
				},
			},
			service: "PHIO",
			showAltPremium: true,
			showApply: true,
			transactionId: 2204639,
			whatHappensNext: ""
	};
}