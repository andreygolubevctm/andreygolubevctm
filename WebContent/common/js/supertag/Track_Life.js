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
			
			var emailId = "";
			var tmpEmailId = Track._getEmailId(email, mkt_opt_in, ok_to_call);
			if( tmpEmailId ) {
				emailId = tmpEmailId;
			}
			
				tran_id = tran_id || referenceNo.getTransactionID(false);

			var fields = {
				vertical:				this._type,
				actionStep:				actionStep,
					quoteReferenceNumber: 	tran_id,
					transactionID: 			tran_id,
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
			var prodArray=[];
			var rank = 1;
			var length = Results._currentPrices.primary.length;
			for (var i = 0; i < length; i += 1) {
				prodArray.push({
					productID : Results._currentPrices.primary[i].product_id,
					ranking : rank++
				});
			}
			
			try {				
				superT.trackQuoteProductList({products:prodArray});
				
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
				superT.trackProductView({productID: product_id});
			} catch(err) {
				/* IGNORE */
			}
		};
		
		Track.onSaveQuote = function() {
			try {
				superT.trackQuoteEvent({
					action:  "Save",
					transactionID:	referenceNo.getTransactionID(false)
				});
			} catch(err) {
				/* IGNORE */
			}
		};
		
		Track.onRetrieveQuote = function() {
			Track.onQuoteEvent("Retrieve");
		};
		
		Track.onQuoteEvent = function( action ) {
			try {
				var tranId = referenceNo.getTransactionID(false);
				
				superT.trackQuoteEvent({
				      action: 			action,
				      transactionID:	tranId
				});
			} catch(err) {
				/* IGNORE */
			}
		};
		
		Track.onQuoteEvent = function(action, tran_id) {
			try {
				tran_id = tran_id || referenceNo.getTransactionID(false);

				superT.trackQuoteEvent({
					action: 		action,
					transactionID:	parseInt(tran_id, 10)
				});
			}
			catch(err) {
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
				var transId = referenceNo.getTransactionID(true);
				superT.contactCentreUser({
					contactCentreID:		contactcentre_id,
					quoteReferenceNumber: 	transId,
					transactionID: 			transId,
					productID: 				product_id
				});
			} catch(err) {
				/* IGNORE */
			}
		};

		Track._getEmailId = function(emailAddress, marketing, oktocall) {
			var emailId = '';

			if(emailAddress) {
				var dat = {brand:Settings.brand, vertical:Settings.vertical, email:emailAddress, m:marketing, o:oktocall};
				$.ajax({
					url: "ajax/json/get_email_id.jsp",
					data: dat,
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