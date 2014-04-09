var Track_Home = new Object();

Track_Home = {
		init: function() {

			Track.init('Home' , 'Cover Start');
			PageLog.log("Cover Start");

			/* Tracking extensions for Car Quote (extend the object - no need for prototype extension as there should only ever be one Track */
			Track.nextClicked = function(stage){
				var actionStep='';
				switch(stage){
				case 1:
					actionStep='The Property';
					PageLog.log("The Property");
					break;
				case 2:
					actionStep='Policy holder';
					PageLog.log("Policy holder");
					break;
				case 3:
					actionStep='Policy Step 4';
					PageLog.log("Policy holder");
					break;
				}

				try {
					superT.trackQuoteForms( fields );
				} catch(err) {
					/* IGNORE */
				}
			};

			/* @Override resultsShown */
			Track.resultsShown=function(eventType){

				PageLog.log("Results");
				var prodArray=new Array();
				var j=0;
				for (var i in Results._currentPrices){
					if (Results._currentPrices[i].available==='Y'){
						var rank=1+parseInt(j);
						prodArray[j]={
							productID : Results._currentPrices[i].productId,
							ranking : rank
						};
						j++;
					}
				}
				try {
					superT.trackQuoteProductList({products:prodArray});

					superT.trackQuoteForms({
						paymentPlan: $('#quote_paymentType option:selected').text(),
						preferredExcess: $('#quote_excess option:selected').text(),
						sortEnvironment: Track._getSliderText('small-env'),
						sortDriveLessPayLess:  Track._getSliderText('small-payasdrive'),
						sortBestPrice: Track._getSliderText('small-price'),
						sortOnlineOnlyOffer: Track._getSliderText('small-onlinedeal'),
						sortHouseholdName: Track._getSliderText('small-household'),
						event: eventType
					});
				} catch(err){}
			};
			Track.compareClicked= function(){
				var prodArray=new Array();
				$('#basket .basket-items .item').each(function(i,obj){
					prodArray[i]={
						productID:$(this).attr('id').substring(19)
					};
				});
				PageLog.log("CompareProducts");
				try {
					superT.trackQuoteComparison({ products: prodArray });
				} catch(err){}

			};
			Track._getSliderText= function(sliderId){
				var s=$('#'+sliderId).prev('span');
				if (s.length >0){
					return s.text();
				} else {
					return '';
				}
			};
			Track._getEmailId = function(emailAddress,marketing,oktocall) {
				var emailId = '';
				var mkt = (marketing) ? 'Y' : 'N';
				var ok = (oktocall) ? 'Y' : 'N';
				if(emailAddress) {
					$.ajax({
						url: "ajax/json/get_email_id.jsp",
						data: "s=CTCQ&email=" + emailAddress + "&m=" + mkt + "&o=" + ok,
						type: "GET",
						async: false,
						dataType: "json",
						success: function(msg){
							emailId = msg.emailId;
						},
						timeout: 20000
					});
					return emailId;
				}
			};
			Track._getTransactionId = function( reset ) {
				reset = (reset===true) ? true : false;
				return ( typeof meerkat !== "undefined" ? meerkat.modules.transactionId.get() : referenceNo.getTransactionID(reset) );
			};

			Track.startSaveRetrieve = function(transId, action, step) {
				var stObj={
						action: action,
						transactionID: transId,
						actionStep: step
					};
				try {
					superT.trackQuoteEvent(stObj);
				} catch(err){}
			};

			Track.onApplyClick = function( product ){
				try{
					superT.trackHandoverType({
						type: 				"Online",
						quoteReferenceNumber: product.transactionId,
						transactionID: 		product.transactionId,
						productID: 			product.productId
					});
				}
				catch(err){
					//console.log(err);
				}
			};
			Track.bridgingClick = function(transId, quoteNo, productId, elementId){
				superT.trackBridgingClick ({
					type: elementId
					, quoteReferenceNumber: quoteNo
					, transactionID: transId
					, productID: productId
				});

			};
		}
	};