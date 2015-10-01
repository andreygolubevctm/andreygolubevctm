;(function($, undefined){

	var meerkat = window.meerkat,
		emailBrochuresSettings = {},
		meerkatEvents = meerkat.modules.events,
		log = meerkat.logging.info,
		msg = meerkat.messaging;

	var events = {
		emailBrochures: {
			QUOTE_SAVED:"EMAIL_BROCHURE_SAVED",
			DESTROY : "EMAIL_BROCHURE_DESTROY"
		}
	},
	moduleEvents = events.emailBrochures;

	var defaultSettings = {
		sendEmailDataFunction : getEmailData,
		canEnableSubmit : canEnableSubmit,
		submitUrl : "productBrochures/send/email.json",
		lockoutOnCheckUserExists : true
	};

	function setup(instanceSettings){
		var settings = $.extend({}, defaultSettings, instanceSettings);
		//Clean up any existing listeners
		tearDown(settings);

		settings = meerkat.modules.sendEmail.setup(settings);
		settings.emailBrochuresOnClickFunction = function() {
			meerkat.messaging.publish(meerkat.modules.events.sendEmail.REQUEST_SEND, {
				instanceSettings: settings
			});
		};

		settings.submitButton.on("click", settings.emailBrochuresOnClickFunction);

		emailBrochuresSettings[settings.identifier] = settings;

		return settings;
	}

	function tearDown(instanceSettings) {
		var existingSettings = emailBrochuresSettings[instanceSettings.identifier];
		if (typeof existingSettings !== 'undefined' && existingSettings !== null) {
			emailBrochuresSettings[existingSettings.identifier] = null;
			meerkat.modules.sendEmail.tearDown(existingSettings);
			existingSettings.submitButton.off("click", existingSettings.emailBrochuresOnClickFunction);
		}
	}

	function canEnableSubmit(instanceSettings){
		return instanceSettings.emailInput.valid();
	}

	function getEmailData(settings){
		var dat = null;
		if(typeof settings.productData !== 'undefined'){
			dat = settings.productData;
		} else {
			dat = [];
		}


		dat = meerkat.modules.sendEmail.purgefromData('premiumFrequency', dat);
		dat.push({name:'premiumFrequency',value: Results.settings.frequency});

		dat = meerkat.modules.sendEmail.purgefromData('marketing', dat);
		dat.push({name:'marketing',value: settings.marketing.val()});

		return dat;
	}

	meerkat.modules.register("emailBrochures", {
		setup: setup,
		events: events,
		tearDown : tearDown
	});

})(jQuery);

function getProduct() {
	return {
		transactionId: 2204639,
		ambulance: {},
		promo: {},
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
			}
		},
		service: "PHIO",
		showAltPremium: true,
		showApply: true,
		whatHappensNext: ""
	};
	return {
		transactionId: 2204639,
		ambulance: {},
		promo: {},
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
			}
		},
		service: "PHIO",
		showAltPremium: true,
		showApply: true,
		whatHappensNext: ""
	};
}