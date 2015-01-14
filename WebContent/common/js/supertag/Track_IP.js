var Track_IP = {

	init: function() {

		Track.init('IP','Details');
		
		Track.updateEVars = function() {
			s.eVar63	= $('#ip_primary_insurance_value').val();	// IP: Indemnity
			s.eVar64	= $('#ip_primary_insurance_waiting').val();	// IP: Waiting Period
			s.eVar65	= $('#ip_primary_insurance_benefit').val();	// IP: Benefit Period
		};

		Track.nextClicked = function(stage, tran_id) {
			var actionStep = false;
			
			switch(stage){
				case 0:
					actionStep = "Income Details";
					Track.updateEVars();
					break;
				case 1:
					actionStep = 'Income Compare'; 
					Track.updateEVars();
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
			var ok_to_call = 	$('input[name=ip_contactDetails_call]:checked', '#mainform').val() == "Y" ? "Y" : "N";
			var mkt_opt_in = 	$("#ip_contactDetails_optIn").is(":checked") ? "Y" : "N";	
			
			var emailId = "";
			var tmpEmailId = Track._getEmailId(email, mkt_opt_in, ok_to_call);
			if( tmpEmailId ) {
				emailId = tmpEmailId;
			}
			
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
				
				superT.trackQuoteResultsList({
				      paymentPlan: 			plan,
					event: eventType,
					products:prodArray
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
				Track.updateEVars();
				superT.trackQuoteEvent({
					action:  "Save",
					transactionID:	( typeof meerkat !== "undefined" ? meerkat.modules.transactionId.get() : referenceNo.getTransactionID(true) )
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
				var tranId = ( typeof meerkat !== "undefined" ? meerkat.modules.transactionId.get() : referenceNo.getTransactionID(true) );
				
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
				tran_id = tran_id || ( typeof meerkat !== "undefined" ? meerkat.modules.transactionId.get() : referenceNo.getTransactionID(true) );

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
					quoteReferenceNumber:	product.api_ref,
					transactionID: 			product.transaction_id,
					productID: 				product.product_id
				});
			} catch(err) {
				/* IGNORE */
			}
		};
		
		Track.contactCentreUser = function( product_id, contactcentre_id ) {
			try {
				var tranId = ( typeof meerkat !== "undefined" ? meerkat.modules.transactionId.get() : referenceNo.getTransactionID(true) );
				superT.contactCentreUser({
					contactCentreID:		contactcentre_id,
					quoteReferenceNumber: 	tranId,
					transactionID: 			tranId,
					productID: 				product_id
				});
			} catch(err) {
				/* IGNORE */
			}
		};

		Track._getEmailId = function(emailAddress, marketing, oktocall) {
			var emailId = '';

			if(emailAddress) {
				var dat = {
					vertical:Settings.vertical, 
					email:emailAddress, 
					m:marketing, 
					o:oktocall,
					transactionId:referenceNo.getTransactionID()
				};

				$.ajax({
					url: "ajax/json/get_email_id.jsp",
					data: dat,
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