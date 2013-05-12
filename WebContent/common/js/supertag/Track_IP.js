var Track_IP = {

	init: function() {
		Track.init('IP','Details');
		
		Track.nextClicked = function(stage) {
			var actionStep = false;
			
			switch(stage){
				case 0:
					actionStep = "Income Details";
					PageLog.log("Income Details");
					break;
				case 1:
					actionStep = 'Income Compare'; 
					PageLog.log("Income Compare");
					break;
				case 2:
					actionStep = 'Income Apply'; 
					PageLog.log("Income Apply");
					break;
				case 3:
					actionStep = 'Income Confirmation'; 
					PageLog.log("Income Confirmation");
					break;
			}
			
			if( actionStep !== false ) {
				var gender = "";
				if( $('input[name=ip_details_primary_gender]:checked', '#mainform') ) {
					if( $('input[name=ip_details_primary_gender]:checked', '#mainform').val() == "M" ) {
						gender = "Male";
					} else {
						gender = "Female";
					}
				};
				
				var yob = "";
				if($("#ip_details_primary_dob").val().length) {
					yob = $("#ip_details_primary_dob").val().split("/")[2];
				}
				
				var postcode = 		$("#ip_details_primary_postCode").val();
				var state = 		$("#ip_details_primary_state").val();
				var email = 		$("#ip_contactDetails_email").val();
				var ok_to_call = 	$('input[name=ip_contactDetails_call]:checked', '#mainform').val() == "Y" ? "Y" : "N";
				var mkt_opt_in = 	$("#ip_contactDetails_optIn").is(":checked") ? "Y" : "N";	
				
				var emailId = "";
				var tmpEmailId = Track._getEmailId(email, mkt_opt_in, ok_to_call);
				if( tmpEmailId ) {
					emailId = tmpEmailId;
				}
				
				var fields = {
					vertical:				this._type,
					actionStep:				actionStep,
					quoteReferenceNumber: 	Track._getTransactionId(),
					transactionID: 			Track._getTransactionId(),
					yearOfBirth: 			yob,
				    gender: 				gender,
				    postCode: 				postcode,
				    state: 					state,
				    emailID: 				emailId,
				    marketOptIn: 			mkt_opt_in,
				    okToCall: 				ok_to_call
				};
				
				try {
					superT.trackQuoteForms( fields );
				} catch(err) {
					/* IGNORE */
				}
			}
		};
		
		Track.onResultsShown = function(eventType) {
			PageLog.log("Income Compare");
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
				switch($('#ip_details_primary_insurance_frequency').val()) {
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
				Track.nextClicked(2);
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
					data: "s=IP&email=" + emailAddress + "&m=" + marketing + "&o=" + oktocall,
					type: "GET",
					async: false,
					dataType: "json",
					success: function(msg){
						emailId = msg.emailId;
					}
				});	
				
				return emailId;
			}
		};
	}	
};