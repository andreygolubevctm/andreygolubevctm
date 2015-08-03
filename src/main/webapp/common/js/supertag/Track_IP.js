var Track_IP = {

	init: function() {

		Track.init('IP','Details');
		
		Track.updateEVars = function() {
			return {
				IPIndemnityValue: $('#ip_primary_insurance_value').val(),
				IPWaitingPeriod: $('#ip_primary_insurance_waiting').val(),
				IPBenefitPeriod: $('#ip_primary_insurance_benefit').val()
		};
		};

		Track.nextClicked = function(stage, tran_id) {
			var actionStep = false;
			
			switch(stage){
				case 0:
					actionStep = "Income Details";
					break;
				case 1:
					actionStep = 'Income Compare'; 
					break;
				case 2:
					actionStep = 'Income Apply'; 
					Write.touchQuote('A');
					break;
				case 3:
					actionStep = 'Income Confirmation'; 
					break;
			}
			
			if( actionStep !== false ) {
			var gender = "";
				if( $('input[name=ip_primary_gender]:checked', '#mainform') ) {
					if( $('input[name=ip_primary_gender]:checked', '#mainform').val() == "M" ) {
					gender = "Male";
				} else {
					gender = "Female";
				}
			};
			
			var yob = "";
				if($("#ip_primary_dob").val().length) {
					yob = $("#ip_primary_dob").val().split("/")[2];
			}
			
				var postcode = 		$("#ip_primary_postCode").val();
				var state = 		$("#ip_primary_state").val();

			var email = 		$("#ip_contactDetails_email").val();
			
				tran_id = tran_id || ( typeof meerkat !== "undefined" ? meerkat.modules.transactionId.get() : referenceNo.getTransactionID(true) );

			var fields = {
				vertical:				this._type,
				actionStep:				actionStep,
					quoteReferenceNumber: 	tran_id,
					transactionID: 			tran_id,
				yearOfBirth: 			yob,
			    gender: 				gender,
			    postCode: 				postcode,
			    state: 					state,
					email:	 				email,
					emailID: 				null
			};
			
				fields = $.extend({}, fields, Track.updateEVars());

				Track.runTrackingCall('trackQuoteForms', fields);
			}
		};
		
		Track.onResultsShown = function(eventType) {
			var prodArray=[];
			var rank = 1;
			var length = Results._currentPrices.primary.length;
			for (var i = 0; i < length; i += 1) {
				prodArray.push({
					productID : Results._currentPrices.primary[i].product_id,
					productBrandCode : Results._currentPrices.primary[i].company,
					productName : Results._currentPrices.primary[i].description,
					ranking : rank++
				});
			}
			
				var plan = "Annual Payment";
				switch($('#ip_primary_insurance_frequency').val()) {
					case "A":
						plan = "Annual Payment";
						break;
					case "H":
					case "M":
					default:
						plan = "Instalment Payments";
						break;
				}
			Track.runTrackingCall('trackQuoteResultsList', {
				paymentPlan: plan,
					event: eventType,
					products:prodArray
				});
		};
		
		Track.onMoreInfoClick = function(product_id) {
			Track.runTrackingCall('trackProductView', {productID: product_id});
		};
		
		Track.onSaveQuote = function() {
			var fields = {
				action:  "Save"
		};
			fields = $.extend({}, fields, Track.updateEVars());
			Track.runTrackingCall('trackQuoteEvent', fields);
		};
		
		Track.onRetrieveQuote = function() {
			Track.onQuoteEvent("Retrieve");
		};
		
		Track.onQuoteEvent = function(action, tran_id) {
			try {
				tran_id = tran_id || ( typeof meerkat !== "undefined" ? meerkat.modules.transactionId.get() : referenceNo.getTransactionID(true) );
			} catch(err) {
				/* IGNORE */
			}
		
			Track.runTrackingCall('trackQuoteEvent', {
					action: 		action,
					transactionID:	parseInt(tran_id, 10)
				});
		};

		Track.onCallMeBackClick = function(product) {
			if(!product) {
				return;
			}
			Track.runTrackingCall('trackQuoteHandoverClick', {
					quoteReferenceNumber:	product.api_ref,
					transactionID: 			product.transaction_id,
					productID: 				product.product_id
				});
		};
		
		Track.onContactDetailsCollected = function(splitTest) {
			splitTest = (splitTest && splitTest != "0") ? splitTest : null;
			
			Track.runTrackingCall('trackContactDetailsCollected', {
				currentJourney: splitTest,
				emailAddress: $('#ip_contactDetails_email').val() ? "Y" : "N",
				okToCall: $('#ip_contactDetails_contactNumberinput').val() ? "Y" : "N",
				marketOptIn: $("#ip_contactDetails_optIn").is(":checked") ? "Y" : "N"
			});
		};
			}
};