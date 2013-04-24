var Track_Life = {

	init: function() {
		Track.init('Life','Needs');
		
		Track.nextClicked = function(stage) {
			var actionStep = false;
			
			switch(stage){
				case 0:
					actionStep = "life needs";
					PageLog.log("life needs");
					break;
				case 1: 
					actionStep = 'life details'; 
					PageLog.log("life details");
					break;
				case 2: 
					actionStep = 'life compare'; 
					PageLog.log("life compare");
					break;
				case 3:
					actionStep = 'life apply'; 
					PageLog.log("life apply");
					break;
				case 4:
					actionStep = 'life confirmation'; 
					PageLog.log("income confirmation");
					break;
			}
			
			if( actionStep !== false ) {
				var gender = "";
				if( $('input[name=life_details_primary_gender]:checked', '#mainform') ) {
					if( $('input[name=life_details_primary_gender]:checked', '#mainform').val() == "M" ) {
						gender = "Male";
					} else {
						gender = "Female";
					}
				};

				var yob = "";
				if($("#life_details_primary_dob").val().length) {
					yob = $("#life_details_primary_dob").val().split("/")[2];
				}

				var postcode =		$("#life_details_primary_postCode").val();
				var state =			$("#life_details_primary_state").val();
				var email =			$("#life_contactDetails_email").val();
				var ok_to_call =	$('input[name=life_contactDetails_call]:checked', '#mainform').val() == "Y" ? "Y" : "N";
				var mkt_opt_in =	$("#life_contactDetails_optIn").is(":checked") ? "Y" : "N";

				var emailId = "";
				var tmpEmailId = Track._getEmailId(email, mkt_opt_in, ok_to_call);
				if( tmpEmailId ) {
					emailId = tmpEmailId;
				}

				var fields = {
					vertical:				this._type,
					actionStep:				actionStep,
					quoteReferenceNumber:	Track._getTransactionId(),
					transactionID:			Track._getTransactionId(),
					yearOfBirth: 			yob,
					gender:					gender,
					postCode:				postcode,
					state:					state,
					emailID:				emailId,
					marketOptIn:			mkt_opt_in,
					okToCall:				ok_to_call
				};

				try {
					superT.trackQuoteForms( fields );
				} catch(err) {
					/* IGNORE */
				}
			}
		};
		
		Track.onResultsShown = function(eventType) {
			PageLog.log("life compare");
			var prodArray=[];
			var rank = 1;
			for (var i in Results._currentPrices) {
				prodArray.push({
					productID : Results._currentPrices[i].product_id,
					ranking : rank++
				});
			}
			
			try {				
				superT.trackQuoteProductList({products:prodArray});
				
				var plan = "Annuall Payment";
				switch($('#life_details_primary_insurance_frequency').val()) {
					case "A":
						plan = "Annual Payment";
						break;
					case "H":
					case "M":
					default:
						plan = "Instalment Payments";
						break;
				}
				
				superT.trackQuoteList ({
				      paymentPlan: 			plan,
				      event: 				eventType
				});
			} catch(err) {
				/* IGNORE */
			}
		};
		
		Track.onMoreInfoClick = function(product_id) {
			try {
				Track.nextClicked(3);
				superT.trackProductView({productID: product_id});
			} catch(err) {
				/* IGNORE */
			}
		};
		
		Track.onSaveQuote = function() {
			Track.onQuoteEvent("Save");
		};
		
		Track.onRetrieveQuote = function() {
			Track.onQuoteEvent("Retrieve");
		};
		
		Track.onQuoteEvent = function( action ) {
			try {
				var tranId = parseInt(Track._getTransactionId());
				
				superT.trackQuoteEvent({
				      action: 			action,
				      transactionID:	tranId
				});
			} catch(err) {
				/* IGNORE */
			}
		};
		
		Track.onCallMeBackClick = function(product) {
			try {
				superT.trackHandover({
					quoteReferenceNumber:	product.client_ref,
					transactionID: 			product.transaction_id,
					productID: 				product.product_id
				});
			} catch(err) {
				/* IGNORE */
			}
		};
		
		Track.contactCentreUser = function( product_id, contactcentre_id ) {
			try {
				superT.contactCentreUser({
					contactCentreID:		contactcentre_id,
					quoteReferenceNumber: 	Track._getTransactionId(),
					transactionID: 			Track._getTransactionId(),
					productID: 				product_id
				});
			} catch(err) {
				/* IGNORE */
			}
		};

		Track._getTransactionId = function() {
			return ReferenceNo.getTransactionID( ReferenceNo._FLAG_PRESERVE );
		};
		
		Track._getEmailId = function(emailAddress, marketing, oktocall) {
			var emailId = '';

			if(emailAddress) {
				$.ajax({
					url: "ajax/json/get_email_id.jsp",
					data: "s=LIFE&email=" + emailAddress + "&m=" + marketing + "&o=" + oktocall,
					type: "GET",
					async: false,
					dataType: "json",
					success: function(msg) {
						emailId = msg.emailId;
					}
				});	
				
				return emailId;
			}
		};
	}	
};