var Track_Utilities = {

	init: function()
	{
		Track.init('Utilities','Household');
		
		Track.nextClicked = function(stage)	{
			var actionStep = false;
			
			var postcode = 		$("#utilities_householdDetails_postcode").val();
			var state = 		$("#utilities_householdDetails_state").val();
			var email = 		$("#utilities_resultsDisplayed_email").val();
			var email2 = 		$("#utilities_application_details_email").val();
			var ok_to_call = 	"N"; //Field not required in questionset (PRJAGGU-33)
			var mkt_opt_in = 	$("#utilities_application_thingsToKnow_receiveInfo").is(":checked") ? "Y" : "N";
			
			var gender = "";
			switch( $('#utilities_application_details_title').val() ) {
				case 'Mr':
					gender = "M";
				case 'Mrs':
				case 'Miss':
				case 'Ms':
					gender = "F";
				default:
					gender = "";
			}
			
			var yob = "";
			if($("#utilities_application_details_dob").val().length) {
				yob = $("#utilities_application_details_dob").val().split("/")[2];
			}
			
			// Set email to application email if provided and is different
			if( email2.length ) {
				email = email2;
			}
			
			var emailId = "";
			var tmpEmailId = Track._getEmailId(email, mkt_opt_in, ok_to_call);
			if( tmpEmailId ) {
				emailId = tmpEmailId;
			}
			
			
			switch(stage) {
				case 0:
					actionStep = "Energy Household";
					PageLog.log("Energy Household");
					break;
				case 1: 
					actionStep = 'Energy Choose'; 
					PageLog.log("Energy Choose");
					break;
				case 1.5:
					actionStep = 'Energy Product Popup'; 
					PageLog.log("Energy Product Popup");
					break;
				case 2: 
					actionStep = 'Energy Your Details'; 
					PageLog.log("Energy Your Details");
					break;
				case 3: 
					actionStep = 'Energy Apply Now'; 
					PageLog.log("Energy Apply Now");
					email = $("#utilities_application_details_email").val();
					break;
				case 4: 
					actionStep = 'Energy Confirmation'; 
					PageLog.log("Energy Confirmation");
					email = $("#utilities_application_details_email").val();
					break;
			}
			
			if( actionStep != false ) {
								
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
			PageLog.log("Energy Choose");
			var prodArray=[];
			var rank = 1;
			for (var i in Results._currentPrices) {
				prodArray.push({
					productID : Results._currentPrices[i].productId,
					ranking : rank++
				});
			}
			
			try {				
				superT.trackQuoteProductList({products:prodArray});				
				superT.trackQuoteList({event:eventType});
			} catch(err) {
				/* IGNORE */
			}
		};
		
		Track.onMoreInfoClick = function(product_id) {
			try {
				Track.nextClicked(1.5);
				superT.trackProductView({productID: product_id});
			} catch(err) {
				/* IGNORE */
			}
		};
		
		Track.onConfirmation = function( product ) {
			try {
				superT.completedApplication({
					quoteReferenceNumber: product.transactionId,
					transactionID: 		product.transactionId,
					productID: 			product.productId
				});
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

		Track._getTransactionId = function() {
			var transId = '';
			var dat = {quoteType:"utilities"};
			dat.id_handler = "preserve_tranId";
			$.ajax({
				url: "ajax/json/get_transactionid.jsp",
				dataType: "json",
				data: dat,
				type: "GET",
				async: false,
				cache: false,
				beforeSend : function(xhr,setting) {
					var url = setting.url;
					var label = "uncache",
					url = url.replace("?_=","?" + label + "=");
					url = url.replace("&_=","&" + label + "=");
					setting.url = url;
				},
				success: function(msg){
					transId = msg.transactionId;
				},
				timeout: 20000
			});

			return transId;
		};
		
		Track._getEmailId = function(emailAddress, marketing, oktocall) {
			var emailId = '';

			if(emailAddress) {
				$.ajax({
					url: "ajax/json/get_email_id.jsp",
					data: "brand=" + Settings.brand + "&vertical=" + Settings.vertical + "&email=" + emailAddress + "&m=" + marketing + "&o=" + oktocall,
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