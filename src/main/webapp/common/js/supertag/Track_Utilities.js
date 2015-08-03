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
			var ok_to_call = 	$("#utilities_privacyoptin").is(":checked") ? "Y" : "N";
			var mkt_opt_in = 	$("#utilities_privacyoptin").is(":checked") ? "Y" : "N";


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
			var yob_raw = $("#utilities_application_details_dob").val();

			if(typeof yobraw != 'undefined' && yobraw.length) {
				yob = $("#utilities_application_details_dob").val().split("/")[2];
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
					actionStep = 'Energy Confirmation';
					email = $("#utilities_application_details_email").val();
					// TODO MAP TO NEW CHECKBOX
					ok_to_call = "N";
					mkt_opt_in = $("#utilities_application_thingsToKnow_receiveInfo").val();
					break;
			}

			if( actionStep != false ) {

				tran_id = tran_id || ( typeof meerkat !== "undefined" ? meerkat.modules.transactionId.get() : referenceNo.getTransactionID(false) );

				var fields = {
					vertical:				this._type,
					actionStep:				actionStep,
					quoteReferenceNumber: 	tran_id,
					transactionID: 			tran_id,
					yearOfBirth: 			yob,
					gender: 				gender,
					postCode: 				postcode,
					state: 					state,
					email: 					email,
					emailID: 				null,
					marketOptIn: 			mkt_opt_in,
					okToCall: 				ok_to_call
				};

				Track.runTrackingCall('trackQuoteForms', fields);
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
			Track.runTrackingCall('trackQuoteResultsList', {
				event:eventType,
				products:prodArray
			});
		};

		Track.onMoreInfoClick = function(product_id) {
			if(!product_id) {
				return;
			}
			Track.nextClicked(1.5);
			Track.runTrackingCall('trackProductView', {productID: product_id});
		};

		Track.onConfirmation = function( product ) {
			if(!product) {
				return;
			}
			Track.runTrackingCall('completedApplication', {
				quoteReferenceNumber: product.transactionId,
				transactionID: 		product.transactionId,
				productID: 			product.productId
			});

		};

		Track.onSaveQuote = function() {
			Track.runTrackingCall('trackQuoteEvent', {
				action:  "Save",
				transactionID:	( typeof meerkat !== "undefined" ? meerkat.modules.transactionId.get() : referenceNo.getTransactionID(false) )
			});
		};

		Track.onRetrieveQuote = function() {
			Track.onQuoteEvent("Retrieve");
		};

		Track.onQuoteEvent = function(action, tran_id) {
			try {
				tran_id = tran_id || ( typeof meerkat !== "undefined" ? meerkat.modules.transactionId.get() : referenceNo.getTransactionID(false) );
			}
			catch(err) {
				/* IGNORE */
			}

			Track.runTrackingCall('trackQuoteEvent', {
				action:  action,
				transactionID:	parseInt(tran_id, 10)
			});
		};

	}
};