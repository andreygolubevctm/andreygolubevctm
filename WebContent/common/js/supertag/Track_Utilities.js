var Track_Utilities = {

	init: function()
	{
		Track.init('Utilities','Household');

		Track.nextClicked = function(stage, tran_id) {
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
					break;
				case 1:
					actionStep = 'Energy Choose';
					break;
				case 1.5:
					actionStep = 'Energy Product Popup';
					break;
				case 2:
					actionStep = 'Energy Your Details';
					Write.touchQuote('A');
					break;
				case 3:
					actionStep = 'Energy Apply Now';
					Write.touchQuote('H', false, 'UTL review', true);
					email = $("#utilities_application_details_email").val();
					break;
				case 4:
					actionStep = 'Energy Confirmation';
					email = $("#utilities_application_details_email").val();
					break;
			}

			if( actionStep != false ) {

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
					action: 		action,
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

		Track._getEmailId = function(emailAddress, marketing, oktocall) {
			var emailId = '';

			if (emailAddress) {
				var dat = {brand:Settings.brand, vertical:Settings.vertical, email:emailAddress, m:marketing, o:oktocall};
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