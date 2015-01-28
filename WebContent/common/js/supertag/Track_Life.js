var Track_Life = {

	init: function() {
		Track.init('Life','Needs');
		
		Track.nextClicked = function(stage, tran_id) {
			var actionStep = false;
			
			switch(stage){
				case 0:
					actionStep = 'life details';
					break;
				case 1: 
					actionStep = 'life compare';
					break;
				case 2: 
					actionStep = 'life apply';
					Write.touchQuote('A');
					break;
				case 3:
					actionStep = 'life confirmation'; 
					break;
			}
			
			if( actionStep !== false ) {
			var gender = "";
				if( $('input[name=life_primary_gender]:checked', '#mainform') ) {
					if( $('input[name=life_primary_gender]:checked', '#mainform').val() == "M" ) {
					gender = "Male";
				} else {
					gender = "Female";
				}
			};
			
			var yob = "";
				if($("#life_primary_dob").val().length) {
					yob = $("#life_primary_dob").val().split("/")[2];
			}
			
				var postcode = 		$("#life_primary_postCode").val();
				var state = 		$("#life_primary_state").val();
			var email = 		$("#life_contactDetails_email").val();
			var ok_to_call = 	$('input[name=life_contactDetails_call]:checked', '#mainform').val() == "Y" ? "Y" : "N";
			var mkt_opt_in = 	$("#life_contactDetails_optIn").is(":checked") ? "Y" : "N";		
			
				tran_id = tran_id || ( typeof meerkat !== "undefined" ? meerkat.modules.transactionId.get() : referenceNo.getTransactionID(false) );

			var fields = {
				vertical:				this._type,
				actionStep:				actionStep,
					quoteReferenceNumber: 	tran_id,
					transactionID: 			tran_id,
				yearOfBirth: 			yob,
			    gender: 				gender,
					email: 					email,
					emailID:			    null,
			    postCode: 				postcode,
			    state: 					state,
			    marketOptIn: 			mkt_opt_in,
			    okToCall: 				ok_to_call
			};
			
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
				switch($('#life_primary_insurance_frequency').val()) {
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
					products: prodArray
				});
		};
		
		Track.onMoreInfoClick = function(product_id) {
			Track.runTrackingCall('trackProductView', {productID: product_id});
		};
		
		Track.onCalculatorClick = function() {
			Track.runTrackingCall('trackCustomPage', {customPage: "Life Calculator Modal"});
		};

		Track.onSaveQuote = function() {
			Track.runTrackingCall('trackQuoteEvent', {
				action:  "Save"
				});
		};
		
		Track.onRetrieveQuote = function() {
			Track.onQuoteEvent("Retrieve");
		};
		

		Track.onQuoteEvent = function(action, tran_id) {

			try {
				tran_id = tran_id || ( typeof meerkat !== "undefined" ? meerkat.modules.transactionId.get() : referenceNo.getTransactionID(false) );
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
			}
};