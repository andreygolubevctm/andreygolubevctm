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
			if( email2.length && email2 != email ) {
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
			     marketOptIn: 			mkt_opt_in,
			     okToCall: 				ok_to_call,
			     healthCoverType:		cover,
			     healthSituation:		situation
			};
		};
		
		Track.nextClicked = function(stage) {
			var actionStep='';
			
			switch(stage) {
				case 0:
					var test = $("#health_situation").is(":visible");
					actionStep = test ? "Situation" : "Cover";
					PageLog.log(test ? "Situation" : "Cover");
					break;
				case 1: 
					actionStep = 'Details'; 
					PageLog.log("Details");
					break;
				case 2: 
					actionStep = 'Results'; 
					PageLog.log("Results");
					break;
				case 3: 
					actionStep = 'Application'; 
					PageLog.log("Application");
					break;
				case 4: 
					actionStep = 'Payment'; 
					PageLog.log("Payment");
					break;
				case 5: 
					actionStep = 'Confirmation'; 
					PageLog.log("Confirmation");
					break;
			};
			
			var fields = Track.getFormFields();
			fields = $.extend({
				vertical:				this._type,
				actionStep:				actionStep,
				transactionID:			Track._getTransactionId(),
				quoteReferenceNumber:	Track._getTransactionId()
			}, fields);
			
			try {
				superT.trackQuoteForms( fields );
			} catch(err) {
				/* IGNORE */
			}
		};
		
		Track.onResultsShown = function(eventType)
		{
			PageLog.log("Results");
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
			PageLog.log("Results Compare");
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
		
		Track.onSaveQuote = function()
		{
			Track.onQuoteEvent("Save");
		};
		
		Track.onRetrieveQuote = function()
		{
			Track.onQuoteEvent("Retrieve");
		};
		
		Track.onQuoteEvent = function( action, tran_id )
		{
			try
			{
				tran_id = tran_id || Track._getTransactionId();
				
				superT.trackQuoteEvent({
				      action: 			action,
				      transactionID:	parseInt( tran_id)
				});
			}
			catch(err)
			{
				/* IGNORE */
			}
		};
		
		Track.onApplyClick = function( product )
		{
			try
			{
				superT.trackHandoverType({
				      type: 				"Online",
				      quoteReferenceNumber: product.transactionId,
				      transactionID: 		product.transactionId,
				      productID: 			product.productId
				});
			}
			catch(err)
			{
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
		
		Track.onConfirmation = function( product )
		{
			try
			{
				superT.completedApplication({
					quoteReferenceNumber: Track._getTransactionId(),
					transactionID: 		Track._getTransactionId(),
					productID: 			product.productId
				});
			}
			catch(err)
			{
				/* IGNORE */
			}
		};
		
		Track.contactCentreUser = function( product_id, contactcentre_id ) 
		{
			try
			{
				superT.contactCentreUser({
					contactCentreID:		contactcentre_id,
					quoteReferenceNumber: 	Track._getTransactionId(),
					transactionID: 			Track._getTransactionId(),
					productID: 				product_id
				});
			}
			catch(err)
			{
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
					data: "s=HEALTH&email=" + emailAddress + "&m=" + marketing + "&o=" + oktocall,
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