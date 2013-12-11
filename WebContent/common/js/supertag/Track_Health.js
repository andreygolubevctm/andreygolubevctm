var Track_Health = new Object();

Track_Health = {
	init: function() {
		
		Track.init('Health','Situation');
		
		Track.getFormFields = function() {
			var cover = $("#health_situation_healthCvr").val();
			var state = $("#health_situation_state").val();
			var state2 = $("#health_application_address_state").val();		
			// Set state to application state if provided and is different
			if( state2.length && state2 != state ) {
				state = state2;
			}
			var situation = $("#health_situation_healthSitu").val();
			var postcode = $("#health_application_address_postCode").val();
			var gender = "";
			if( $('input[name=health_application_primary_gender]:checked', '#mainform') ) {
				if( $('input[name=health_application_primary_gender]:checked', '#mainform').val() == "M" ) {
					gender = "Male";
				} else {
					gender = "Female";
				}
			};
			
			var yob = "";
			if( $("#health_healthCover_primary_dob").val().length ) {
				yob = $("#health_healthCover_primary_dob").val().split("/")[2];
			}

			var ok_to_call = $('input[name=health_contactDetails_call]:checked', '#mainform').val() == "Y" ? "Y" : "N";
			var mkt_opt_in = $('input[name=health_application_optInEmail]:checked', '#mainform').val() == "Y" ? "Y" : "N";

			var email = $("#health_contactDetails_email").val();
			var email2 = $("#health_application_email").val();			
			// Set email to application email if provided and is different
			if( email2.length ) {
				email = email2;
			}
			
			var emailId = "";
			var tmpEmailId = Track._getEmailId(email, mkt_opt_in, ok_to_call);
			if( tmpEmailId ) {
				emailId = tmpEmailId;
			}
			
			return {
			     yearOfBirth: 			yob,
			     gender: 				gender,
			     postCode: 				postcode,
			     state: 				state,
			     emailID: 				emailId,
				marketOptIn: 			mkt_opt_in === false ? '' : mkt_opt_in,
				okToCall: 				ok_to_call === false ? '' : ok_to_call,
			     healthCoverType:		cover,
			     healthSituation:		situation
			};
		};
		
		Track.nextClicked = function(stage, tran_id) {
			var actionStep='';
			switch(stage) {
				case 0:
					actionStep = "health situation";
					break;
				case 1: 
					actionStep = 'health details';
					Write.touchQuote('H', false, 'HLT detail', true);
					break;
				case 2: 
					return;
					break;
				case 3: 
					actionStep = 'health application';
					break;
				case 4: 
					actionStep = 'health payment';
					Write.touchQuote('H', false, 'HLT paymnt', true);
					break;
				case 5: 
					actionStep = 'health confirmation';
					break;
			};
			tran_id = tran_id || referenceNo.getTransactionID(false);
			var fields = Track.getFormFields();
			fields = $.extend({
				vertical:				this._type,
				actionStep:				actionStep,
				transactionID:			tran_id,
				quoteReferenceNumber:	tran_id
			}, fields);
			
			try {
				superT.trackQuoteForms( fields );
			} catch(err) {
				/* IGNORE */
			}
		};

		Track.healthResults = function(tran_id) {
			var actionStep = 'health results';
			tran_id = tran_id || referenceNo.getTransactionID(false);
			var fields = Track.getFormFields();
			fields = $.extend({
				vertical:				this._type,
				actionStep:				actionStep,
				transactionID:			tran_id,
				quoteReferenceNumber:	tran_id
			}, fields);
			
			try {
				superT.trackQuoteForms( fields );
			} catch(err) {
				/* IGNORE */
			}
		};
		
		Track.onResultsShown = function(eventType) {
			var prodArray = [];
			var rank = 1;
			for (var i in Results._currentPrices)
			{
				prodArray.push({
					productID : Results._currentPrices[i].productId,
					ranking : rank++
				});
			}
			
			try {		
				superT.trackQuoteProductList({products:prodArray});
				
				var payment = "Annually";
				switch($('input[name=health_show-price]:checked', '#mainform').val())
				{
					case "F":
						payment = "Fortnightly";
						break;
					case "M":
						payment = "Monthly";
						break;
					case "A":
					default:
						payment = "Annually";
						break;
				}
				var ranking = $('input[name=health_rank-by]:checked', '#mainform').val() == "B" ? "Benefits" : "Lowest Price";
				var excess = "ALL";
				switch($("#health_excess").val())
				{
					case 1:
						excess = "0";
						break;
					case 2:
						excess = "1-250";
						break;
					case 3:
						excess = "251-500";
						break;
					case 4:
						default:
						excess = "ALL";
						break;
				}
				
				superT.trackQuoteList ({
				      preferredExcess: 		excess,
				      sortPaymentFrequency:	payment,
				      sortHealthRanking: 	ranking,
				      event: 				eventType
				});
			}
			catch(err)
			{
				/* IGNORE */
			}
		};
		
		Track.onCompareProducts = function( product_ids )
		{
			Write.touchQuote('H', false, 'ResCompare');
			var compareArray = [];
			for (var i = 0; i < product_ids.length; i++)
			{
				compareArray.push({productID : product_ids[i]});
			}
			
			try
			{
				superT.trackQuoteComparison({
				    products: compareArray
				});
			}
			catch(err)
			{
				/* IGNORE */
			}
		};
		
		Track.onSaveQuote = function() {
			try {
				superT.trackQuoteEvent({
					action:  "Save",
					transactionID: referenceNo.getTransactionID(false)
				});
			} catch(err) {
				/* IGNORE */
			}
		};
		
		Track.onRetrieveQuote = function()
		{
			Track.onQuoteEvent("Retrieve");
		};
		
		Track.onQuoteEvent = function(action, tran_id) {
			try {
				tran_id = tran_id || referenceNo.getTransactionID(false);
				
				superT.trackQuoteEvent({
				      action: 			action,
					transactionID:	parseInt(tran_id, 10)
				});
			}
			catch(err) {
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

		Track.onApplyClick = function( product, type ) {
			try {
				type = type || 'Online_R';
				superT.trackHandoverType({
					type: 				type,
				      quoteReferenceNumber: product.transactionId,
				      transactionID: 		product.transactionId,
				      productID: 			product.productId
				});
			} catch(err) {
				/* IGNORE */
			}
		};
		
		Track.onViewJoinDeclaration = function( product_id )
		{
			try
			{
				superT.trackOfferTerms({productID: product_id});
			}
			catch(err)
			{
				/* IGNORE */
			}
		};
		
		Track.onCustomPage = function( page_label )
		{
			try
			{
				superT.trackCustomPage( page_label );
			}
			catch(err)
			{
				/* IGNORE */
			}
		};
		
		Track.onConfirmation = function( product ) {
			try {
				var tranid = referenceNo.getTransactionID(false);
				superT.completedApplication({
					quoteReferenceNumber: tranid,
					transactionID: 		tranid,
					productID: 			product.productId
				});
			} catch(err) {
				/* IGNORE */
			}
		};
		
		Track.contactCentreUser = function( product_id, contactcentre_id ) {
			try {
				superT.contactCentreUser({
					contactCentreID:		contactcentre_id,
					quoteReferenceNumber: 	referenceNo.getTransactionID(false),
					transactionID: 			referenceNo.getTransactionID(false),
					productID: 				product_id
				});
			}
			catch(err)
			{
				/* IGNORE */
			}
		};

		Track._getTransactionId = function() {
			var fetchFromServer = !Health._mode == HealthMode.CONFIRMATION;
			return referenceNo.getTransactionID(fetchFromServer);
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
					success: function(msg){
						emailId = msg.emailId;
					}
				});	
				
				return emailId;
			}
		};

		Track.bridgingClick = function(type, transId, quoteNo, productId) {
			try {
				superT.trackBridgingClick ({
					type: type
					, quoteReferenceNumber: quoteNo
					, transactionID: transId
					, productID: productId
				});
			} catch(err) {
				/* IGNORE */
			}
		};
	}
};